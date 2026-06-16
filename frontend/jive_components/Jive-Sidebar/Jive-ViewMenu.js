import { myAccFunc, createCellWithCode, createMDCellWithUI, getVarName, resolveAfterTimeout, updateAllChevrons, closeOtherAccordions } from "./jive_helpers.js"

function createAccordion(title, items, idSuffix) {
    const accButton = document.createElement("button")
    accButton.className = "jv-button jv-block jv-left-align"
    accButton.name = title
    accButton.style.display = "flex"
    accButton.style.justifyContent = "space-between"
    accButton.style.alignItems = "center"
    accButton.style.fontSize = "0.93em"
    accButton.innerHTML = `
        <span style="display:flex;align-items:center;">
            <span>${title}</span>
        </span>
        <img class="chevron" width="15" style="margin-left:auto;" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg" 
            data-down="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-up="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up-outline.svg">
    `
    const accContent = document.createElement("div")
    accContent.id = "AccView_" + idSuffix
    accContent.className = "jv-hide jv-card"
    accContent.style.boxShadow = "none"
    accContent.style.margin = "0px 0px 5px 15px"
    accContent.style.fontSize = "0.92em"

    items.forEach((item) => accContent.appendChild(item))

    accButton.onclick = function () {
        closeOtherAccordions(accContent.id, "AccProcess_")
        myAccFunc(accContent.id)
        updateAllChevrons()
    }

    const wrapper = document.createElement("div")
    wrapper.appendChild(accButton)
    wrapper.appendChild(accContent)
    return wrapper
}

function createMenuItem(text, onclick) {
    const a = document.createElement("a")
    a.href = "#"
    a.className = "jv-bar-item jv-button jv-left-align"
    a.style.fontSize = "0.93em"
    a.style.display = "flex"
    a.style.alignItems = "center"
    a.innerHTML = `<span>${text}</span>`
    a.onclick = onclick
    return a
}

export function createViewMenu(timeoutValue) {
    // Main View menu button
    const accButtonView = document.createElement("button")
    accButtonView.className = "jv-button jv-block jv-left-align"
    accButtonView.name = "View"
    accButtonView.style.display = "flex"
    accButtonView.style.justifyContent = "space-between"
    accButtonView.style.alignItems = "center"
    accButtonView.innerHTML = `
        <span style="display:flex;align-items:center;">
            <span style="font-size:0.97em;">View</span>
        </span>
        <img class="chevron" width="15" style="margin-left:auto;" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-down="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-up="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up-outline.svg">
    `
    accButtonView.onclick = function () {
        closeOtherAccordions(accView.id)
        myAccFunc(accView.id)
        updateAllChevrons()
    }

    // Main View menu container
    const accView = document.createElement("div")
    accView.id = "AccView"
    accView.className = "jv-hide jv-card"
    accView.style.boxShadow = "none"
    accView.style.margin = "0px 0px 5px 15px"

    // 👁️ View / Display
    const viewDisplayItems = [
            createMenuItem("Mosaic View", async function () {
        
                const sel_imgs = getVarName("mosaic_imgs");
                const sel_times = getVarName("mosaic_times"); // nueva variable para tiempos
                const nrow = getVarName("mosaic_nrow");
                const ncol = getVarName("mosaic_ncol");
        
                ////////////////////////////////////
                // UI
                ////////////////////////////////////
        
                createMDCellWithUI(
                    "Mosaic Image Viewer",
                    `
Images to display:
$(@bind ${sel_imgs} MultiSelect(image_keys))
        
Times to display (per image, 0-indexed):
$(@bind ${sel_times} MultiSelect(0:49))
        
Rows:
$(@bind ${nrow} NumberField(1:10, default=1))
        
Columns:
$(@bind ${ncol} NumberField(1:10, default=1))
                    `
                );
        
                await resolveAfterTimeout(300);
        
                ////////////////////////////////////
                // Visualization
                ////////////////////////////////////
        
                createCellWithCode(`
        let
        
        if !isnothing(${sel_imgs}) && length(${sel_imgs}) > 0
        
            # Extraer imágenes seleccionadas
            imgs = map(k -> image_data[k], ${sel_imgs})
        
            # Si hay selección de tiempos, tomar solo esos frames
            imgs = map(img -> begin
                if !isnothing(${sel_times}) && length(${sel_times}) > 0
                    # img[:, :, sel_times .+ 1]  # Julia es 1-indexed
                    img[:, :, ${sel_times} .+ 1]
                else
                    img
                end
            end, imgs)
        
            println("Displaying mosaic with ", length(imgs), " images, ", length(${sel_times}), " frames per image")
        
            JIVECore.Visualize.mosaicview(
                imgs...;
                nrow=${nrow},
                ncol=${ncol}
            )
        
        end
        
        end
                `);
            }),
        createMenuItem("Zoom In", function () {}),
        createMenuItem("Zoom Out", function () {}),
        createMenuItem("Reset Zoom", function () {}),
        createMenuItem("Pan Tool", function () {}),
        createMenuItem("Fit to Cell Width", function () {}),
        createMenuItem("Fit to Original Size", function () {}),
    ]

    // 🎚️ Contrast & Intensity
    const contrastItems = [
        createMenuItem("Auto Contrast", function () {}),
        createMenuItem("Manual Contrast Sliders", function () {}),
        createMenuItem("Brightness Slider", function () {}),
        createMenuItem("Gamma Adjustment", function () {}),
        createMenuItem("Histogram View", function () {}),
        
            // 1️⃣ Selección de imagen ya cargada
            createMenuItem("Calibrate Image", async function () {

                const sel_im = getVarName("sel_im");
                const calibrate_h = getVarName("calibrate_h");
                const calibrate_v = getVarName("calibrate_v");
                const calibrate_t = getVarName("calibrate_t");
            
                const h_val = getVarName("h_val");
                const h_unit = getVarName("h_unit");
                const v_val = getVarName("v_val");
                const v_unit = getVarName("v_unit");
                const t_val = getVarName("t_val");
                const t_unit = getVarName("t_unit");
            
                const calibrated_key = getVarName("calibrated_key");
            
                ////////////////////////////////////
                // UI PANEL
                ////////////////////////////////////
                createMDCellWithUI(
                    "Calibrate Parameters",
                    `
1. Select Image
$(@bind ${sel_im} Select([nothing, image_keys...]))
            
2. Choose axes to calibrate:
Horizontal $(@bind ${calibrate_h} PlutoUI.CheckBox(true))
Vertical   $(@bind ${calibrate_v} PlutoUI.CheckBox())
Time      $(@bind ${calibrate_t} PlutoUI.CheckBox())
            
Horizontal value: $(@bind ${h_val} NumberField(0:0.001:10, default=0.001))
Horizontal unit: $(@bind ${h_unit} Select(["mm", "μm"]))
            
Vertical value: $(@bind ${v_val} NumberField(0:0.1:10, default=1))
Vertical unit: $(@bind ${v_unit} Select(["mm", "μm"]))
            
Time value: $(@bind ${t_val} NumberField(0:1:100, default=1))
Time unit: $(@bind ${t_unit} Select(["s", "ms"]))
                    `
                );
            
                await resolveAfterTimeout(300);
            
                ////////////////////////////////////
                // PROCESSING
                ////////////////////////////////////
                createCellWithCode(`
            using Unitful

            ${calibrated_key} = nothing

            if !isnothing(${sel_im})

                img = image_data[${sel_im}]

                # Obtener los nombres de los ejes de la imagen
                axes_names = JIVECore.Data.axisnames(img)
                dims = length(axes_names)

                # Crear diccionario de spacings por defecto = 1
                spacings = Dict{Symbol,Any}()
                for ax in axes_names
                    spacings[ax] = 1
                end

                # Reemplazar solo los ejes que el usuario seleccionó
                if ${calibrate_h} && dims >= 1
                    spacings[axes_names[1]] = ${h_val} * (${h_unit} == "mm" ? Unitful.mm : Unitful.μm)
                end

                if ${calibrate_v} && dims >= 2
                    spacings[axes_names[2]] = ${v_val} * (${v_unit} == "mm" ? Unitful.mm : Unitful.μm)
                end

                if ${calibrate_t} && dims >= 3
                    spacings[axes_names[3]] = ${t_val} * (${t_unit} == "s" ? Unitful.s : Unitful.ms)
                end

                # Calibrar imagen con todos los ejes
                img2 = JIVECore.Data.imCalibrate(img; spacings...)

                # Guardar imagen calibrada en el diccionario con keyCheck
                key = JIVECore.Data.keyCheck(image_data, string(${sel_im}, "_calibrated"))
                image_data[key] = img2

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global ${calibrated_key}
                ${calibrated_key} = key

                println("Calibrated image stored as: ", key)
            end

            nothing
                `);
            
                await resolveAfterTimeout(300);
            
                ////////////////////////////////////
                // SHOW INFO
                ////////////////////////////////////
                createCellWithCode(`
            if !isnothing(${calibrated_key})
                JIVECore.Files.showInfo(image_data[${calibrated_key}])
            end
                `);
            
            }),
              
        
    ]        

    // 🌈 Colormap & Channels
    const colormapItems = [
        createMenuItem("Set Colormap (e.g., gray, viridis, magma)", function () {}),
        createMenuItem("Time Color Map", async function () {

            const sel_img = getVarName("timecolor_img");
            const sel_scheme = getVarName("timecolor_scheme");
            const show_res = getVarName("timecolor_show");
        
            const out_key = getVarName("timecolor_key");
        
            ////////////////////////////////////
            // UI
            ////////////////////////////////////
        
            createMDCellWithUI(
                "Time Color Mapping",
                `
Image stack:
$(@bind ${sel_img} Select([nothing, image_keys...]))
        
Color scheme:
$(@bind ${sel_scheme} Select([:batlowW,:batlow,:viridis,:magma,:inferno,:plasma]))

                `
            );
        
            await resolveAfterTimeout(300);
        
            ////////////////////////////////////
            // Processing
            ////////////////////////////////////
        
            createCellWithCode(`
        
        ${out_key} = nothing
        
        let
        
        if !isnothing(${sel_img})
        
            img_full = image_data[${sel_img}]
        
            ##################################
            # Detect time axis automatically
            ##################################
        
            if img_full isa JIVECore.Data.AxisArray
        
                ax = JIVECore.Data.axisnames(img_full)
        
                t_axis = findfirst(x -> lowercase(String(x)) == "time", ax)
        
                if isnothing(t_axis)
                    error("Selected image does not contain a time axis")
                end
        
                data = parent(img_full)
        
                # reorder axes so time is third
                perm = collect(1:ndims(data))
        
                perm[3], perm[t_axis] = perm[t_axis], perm[3]
        
                img = permutedims(data, perm)
        
            else
        
                img = img_full
        
            end
        
            ##################################
            # Apply time color mapping
            ##################################
        
            result = JIVECore.Data.imTimeColor(
                img,
                ${sel_scheme}
            )
        
            base_name = string(${sel_img}, "_timecolor")
        
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = result
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            global ${out_key}
            ${out_key} = key
        
            println("Stored image: ", key)
            println("Size: ", size(result))
        
        
        end
        
        end
        
        nothing
        
        `);
        await resolveAfterTimeout(300);
        
        // 🔹 Checkbox
        createMDCellWithUI(
`$(@bind ${show_res} PlutoUI.CheckBox(default=false)) Show image`,""
        );

        await resolveAfterTimeout(300);
        
        // 🔹 Mostrar imagen
        createCellWithCode(`
    if ${show_res} && !isnothing(${out_key})
        JIVECore.Visualize.gif(
            JIVECore.Process.autoContrast(image_data[${out_key}])
        )
    end
        `);

        
        }),
        createMenuItem("Toggle Channels", function () {}),
        createMenuItem("Split Channels to Layers", function () {}),
        createMenuItem("Channel Opacity", function () {}),
        createMenuItem("Channel Order", function () {}),
    ]

    // 🪟 Slice & Dimension Control
    const sliceItems = [
        createMenuItem("Z-Slice Slider", function () {}),
        createMenuItem("Timepoint Slider (T)", function () {}),
        createMenuItem("Orthogonal Views", function () {}),
        createMenuItem("Toggle 2D / 3D View", function () {}),
    ]

    // 🏷️ Overlays & Annotations
    const overlayItems = [
        createMenuItem("Show / Hide Overlays", function () {}),
        createMenuItem("ROI Display Toggle", function () {}),
        createMenuItem("Add Annotation Layer", function () {}),
        createMenuItem("Label Transparency", function () {}),
        createMenuItem("Outline Thickness", function () {}),
    ]

    // 📐 Scale & Axes
    const scaleItems = [

//////////////////////////
// Draw Scale Bar
//////////////////////////
createMenuItem("Draw Scale Bar", async function () {

    const sel_im = getVarName("sb_im");           // Imagen seleccionada
    const sb_h_size = getVarName("sb_h_size");    // Tamaño barra horizontal
    const sb_v_size = getVarName("sb_v_size");    // Tamaño barra vertical
    const sb_h_corner = getVarName("sb_h_corner");
    const sb_v_corner = getVarName("sb_v_corner");
    const sb_channels = getVarName("sb_channels");
    const sb_out_key = getVarName("sb_out_key");

    ////////////////////////////////////
    // UI PANEL
    ////////////////////////////////////
    createMDCellWithUI(
        "Draw Scale Bar",
        `
Select Image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
    
Horizontal scalebar size:
$(@bind ${sb_h_size} NumberField(0.001:0.001:100, default=50))
Corner H:
$(@bind ${sb_h_corner} Select([:bottomleft, :bottomright, :topleft, :topright], default=:bottomleft))
    
Vertical scalebar size:
$(@bind ${sb_v_size} NumberField(0.001:0.001:100, default=50))
Corner V:
$(@bind ${sb_v_corner} Select([:bottomleft, :bottomright, :topleft, :topright], default=:bottomleft))
        `
    );
    
    await resolveAfterTimeout(300);
    
    createCellWithCode(`
        img_out = nothing
        let
        if !isnothing(${sel_im})


            key = string(${sel_im}, "_scalebar")

            img_orig = image_data[${sel_im}]
            img_out = copy(img_orig)
            
            # Obtener metadata
			axes_vals	=	JIVECore.Data.axisvalues(img_out)
			v_axis = axes_vals[1]  # eje vertical
			h_axis = axes_vals[2]  # eje horizontal
			
			v_unit = unit(first(v_axis))
			h_unit = unit(first(h_axis)) 

        
            # Dibujar scale bars
                JIVECore.Draw.scalebar!(
                    img_out,
                    ${sb_h_size} * h_unit,
                    direction=:h,
                    fontsize=0.04,
                    fcolor=(1,1,1),
                    channels=[:h,:v],
                    corner=${sb_h_corner},
                    show_text=true
                )
            
                JIVECore.Draw.scalebar!(
                    img_out,
                    ${sb_v_size} * v_unit,
                    direction=:v,
                    fontsize=0.04,
                    fcolor=(1,1,1),
                    channels=[:h,:v],
                    corner=${sb_v_corner},
                    show_text=true
                )
        
            
            image_data[key] = img_out

            # Añadir a image_keys si no existe
            if !(key in image_keys)
                push!(image_keys, key)
            end

            global ${sb_out_key}
            ${sb_out_key} = key

            println("Image with scale bar saved as: ", key)
        end

        end
        `);

}),

    createMenuItem("Add Timestamp", async function () {

        const sel_img = getVarName("timestamp_img");  // solo una imagen
        const sel_times = getVarName("timestamp_times"); // opcional, varios frames
        const fontsize = getVarName("timestamp_fontsize");
        const corner = getVarName("timestamp_corner");

        ////////////////////////////////////
        // UI
        ////////////////////////////////////
        createMDCellWithUI(
            "Timestamp Options",
            `
Image to add timestamp:
$(@bind ${sel_img} Select([nothing, image_keys...]))

Font size:
$(@bind ${fontsize} NumberField(0.01:0.01:0.2, default=0.06))

Corner:
$(@bind ${corner} Select(["topleft","topright","bottomleft","bottomright"], default="topright"))
            `
        );

        await resolveAfterTimeout(300);

        ////////////////////////////////////
        // Apply timestamp
        ////////////////////////////////////
        createCellWithCode(`
let
    if !isnothing(${sel_img})

        img = image_data[${sel_img}]

        # Agregar timestamp
        JIVECore.Draw.timestamp!(img_view; channels=[:h,:v,:time], fontsize=${fontsize}, corner=Symbol(${corner}))

        # Sobrescribir la imagen
        image_data[${sel_img}] = img

        println("Timestamp added to image: ", ${sel_img})

end
end
        `);

    }),

        createMenuItem("Set Units", function () {}),
        createMenuItem("Toggle Axes", function () {}),
        createMenuItem("Change Pixel Size", function () {}),
    ]


    // Add accordions to menu
    accView.appendChild(createAccordion("👁️ Display", viewDisplayItems, "display"))
    accView.appendChild(createAccordion("🎚️ Contrast", contrastItems, "contrast"))
    accView.appendChild(createAccordion("🌈 Color", colormapItems, "color"))
    accView.appendChild(createAccordion("🪟 Slice", sliceItems, "slice"))
    accView.appendChild(createAccordion("🏷️ Overlays", overlayItems, "overlay"))
    accView.appendChild(createAccordion("📐 Axes", scaleItems, "axes"))

    

    // Add a line at the end
    const hr = document.createElement("hr")
    hr.style.margin = "12px 0 0 0"
    accView.appendChild(hr)

    // Wrap button and menu
    const itemBarView = document.createElement("div")
    itemBarView.appendChild(accButtonView)
    itemBarView.appendChild(accView)

    return itemBarView
}
