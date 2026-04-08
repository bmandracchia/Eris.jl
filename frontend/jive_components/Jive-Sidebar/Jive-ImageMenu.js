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
    accContent.id = `AccImage_${idSuffix}`
    accContent.className = "jv-hide jv-card"
    accContent.style.boxShadow = "none"
    accContent.style.margin = "0px 0px 5px 15px"
    accContent.style.fontSize = "0.92em"

    items.forEach((item) => accContent.appendChild(item))

    accButton.onclick = function () {
        closeOtherAccordions(accContent.id, "AccImage_")
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

export function createImageMenu(timeoutValue) {
    // Main Image menu button
    const accButtonImage = document.createElement("button")
    accButtonImage.className = "jv-button jv-block jv-left-align"
    accButtonImage.name = "Image"
    accButtonImage.style.display = "flex"
    accButtonImage.style.justifyContent = "space-between"
    accButtonImage.style.alignItems = "center"
    accButtonImage.innerHTML = `
        <span style="display:flex;align-items:center;">
            <span style="font-size:0.97em;">Image</span>
        </span>
        <img class="chevron" width="15" style="margin-left:auto;" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-down="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-up="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up-outline.svg">
    `
    accButtonImage.onclick = function () {
        closeOtherAccordions(accImage.id)
        myAccFunc(accImage.id)
        updateAllChevrons()
    }

    // Main Edit menu container
    const accImage = document.createElement("div")
    accImage.id = "AccImage"
    accImage.className = "jv-hide jv-card"
    accImage.style.boxShadow = "none"
    accImage.style.margin = "0px 0px 5px 15px"

    // --- Submenus ---

    // Types
    const typesItems = [
        createMenuItem("Color Space & Bit Depth Conversion", async function () {

            const sel_im = getVarName("sel_im_bit");
            const colortype = getVarName("colortype");
            const bitrate = getVarName("bitrate");
            const show_info = getVarName("show_info");
            const converted_key = getVarName("converted_key");
        
            createMDCellWithUI(
                "Convert Image Bit Depth",
                `
1. Select image  
$(@bind ${sel_im} Select([nothing, image_keys...]))
        
2. Color type  
$(@bind ${colortype} Select(["gray", "rgb"]))
        
3. Bit depth  
$(@bind ${bitrate} Select([8, 16, 32, 64]))
                `
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
        ${converted_key} = nothing
        
        if !isnothing(${sel_im})
        
            # Nombre automático usando keyCheck
            base_name = string(${sel_im}, "_", ${colortype}, "_", ${bitrate}, "bit")
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            # Solo guardar si no existe
            if !(key in image_keys)
        
                img_original = copy(image_data[${sel_im}])
                img_converted = JIVECore.Data.im2bit(
                    img_original,
                    ${colortype},
                    ${bitrate}
                )
        
                image_data[key] = img_converted
                push!(image_keys, key)
        
                println("Image stored as \\"$(key)\\" ")
            end
        
            ${converted_key} = key
        end
        
        nothing
            `);
        
            await resolveAfterTimeout(300);
        
            createMDCellWithUI(
                `$(@bind ${show_info} PlutoUI.CheckBox(default=false)) Show info of converted image`, ""
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
        if ${show_info} && !isnothing(${converted_key})
            JIVECore.Files.showInfo(image_data[${converted_key}])
        end
        `);
        
        }),
////////////////////////
// CONVERSION TO RGB  //
////////////////////////

            createMenuItem("Convert to RGB Composition", async function () {

                const sel_im = getVarName("rgb_im");
                const rgb_key = getVarName("rgb_key");
                const show_rgb = getVarName("rgb_show");
                const apply_contrast = getVarName("rgb_contrast");

                const sel_r = getVarName("rgb_r");
                const sel_g = getVarName("rgb_g");
                const sel_b = getVarName("rgb_b");

                ////////////////////////////////////
                // UI CELL
                ////////////////////////////////////

                createMDCellWithUI(
                    "RGB Channel Composition",
                    `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Apply auto contrast:
$(@bind ${apply_contrast} PlutoUI.CheckBox(default=true))
            `
                );

                await resolveAfterTimeout(300);

                ////////////////////////////////////
                // Dynamic channel selector
                ////////////////////////////////////

                createCellWithCode(`

            channels_options = begin

            if isnothing(${sel_im})
                [:r,:g,:b]

            else

                img_local = image_data[${sel_im}]

                if img_local isa JIVECore.Data.AxisArray &&
                (:C in JIVECore.Data.axisnames(img_local) ||
                    :c in JIVECore.Data.axisnames(img_local))

                    C_axis = findfirst(
                        x -> lowercase(String(x)) == "c",
                        JIVECore.Data.axisnames(img_local)
                    )

                    nC = size(parent(img_local), C_axis)

                    Symbol.("C" .* string.(1:nC))

                else
                    [:r,:g,:b,:m,:y,:c,:gray]

                end

            end

            end

md"""
RGB Channel Mapping:

R channel:
$(@bind ${sel_r} Select(channels_options))

G channel:
$(@bind ${sel_g} Select(channels_options))

B channel:
$(@bind ${sel_b} Select(channels_options))
"""
`);

                await resolveAfterTimeout(300);

                ////////////////////////////////////
                // Processing pipeline
                ////////////////////////////////////

                createCellWithCode(`

            ${rgb_key} = nothing

            let

            if !isnothing(${sel_im})

                img = copy(image_data[${sel_im}])

                rgb_img = JIVECore.Data.im2rgb(
                    img;
                    channels=[
                        Symbol(${sel_r}),
                        Symbol(${sel_g}),
                        Symbol(${sel_b})
                    ]
                )

                if ${apply_contrast}
                    rgb_img = JIVECore.Process.autoContrast(rgb_img)
                end

                base_name = string(${sel_im}, "_rgb")

                key = JIVECore.Data.keyCheck(image_data, base_name)

                image_data[key] = rgb_img

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global ${rgb_key}
                ${rgb_key} = key

            end

            end

            nothing
            `);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Visualization toggle
    ////////////////////////////////////

    createMDCellWithUI(
        `$(@bind ${show_rgb} PlutoUI.CheckBox(default=false)) Show RGB image`,
        ""
    );

    await resolveAfterTimeout(300);

    createCellWithCode(`

if ${show_rgb} && !isnothing(${rgb_key})
    JIVECore.Visualize.gif(image_data[${rgb_key}])
end

`);

}),

        ///////////////////////
        // CONVERSION TO HSV //
        ///////////////////////
        createMenuItem("Convert to HSV", async function () {
            const sel_im = getVarName("sel_im_hsv");
            const converted_key = getVarName("converted_key_hsv");
            const show_img = getVarName("show_img_hsv");
        
            createMDCellWithUI(
                "Convert RGB to HSV",
                `
1. Select RGB image
$(@bind ${sel_im} Select([nothing, image_keys...]))
                `
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`

                ${converted_key} = nothing
                
                let
                
                if !isnothing(${sel_im})
                
                    img_original = copy(image_data[${sel_im}])
                
                    base_name = string(${sel_im}, "_hsv")
                    key = JIVECore.Data.keyCheck(image_data, base_name)
                
                    if !(key in image_keys)
                
                        img_conv = JIVECore.Data.im2hsv(img_original)
                
                        image_data[key] = img_conv
                        push!(image_keys, key)
                
                        println("Image stored as \\"$(key)\\" ")
                    end
                
                    global ${converted_key}
                    ${converted_key} = key
                end
                    
                end
                
                nothing
            `);

            await resolveAfterTimeout(300);
        
            createMDCellWithUI(
                `$(@bind ${show_img} PlutoUI.CheckBox(default=false)) Show image`, ""
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
            if ${show_img} && !isnothing(${converted_key})

                img_hsv = image_data[${converted_key}]
                JIVECore.Visualize.gif(img_hsv)

            end
        `);

        }),

        /////////////////////////
        // CONVERSION TO FLOAT //
        /////////////////////////

        createMenuItem("Convert to Float Precision", async function () {

            const sel_im = getVarName("sel_im_float");
            const precision = getVarName("precision_float");
            const converted_key = getVarName("converted_key_float");
            const show_info = getVarName("show_info_float");
        
            createMDCellWithUI(
                "Convert Image to Floating Precision",
                `
1. Select image  
$(@bind ${sel_im} Select([nothing, image_keys...]))
        
2. Precision  
$(@bind ${precision} Select([:float32, :float64]))
                `
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
                ${converted_key} = nothing
                let
                
                if !isnothing(${sel_im})
                
                    img_original = copy(image_data[${sel_im}])
                
                    base_name = string(${sel_im}, "_", ${precision})
                    key = JIVECore.Data.keyCheck(image_data, base_name)
                
                    if !(key in image_keys)
                
                        img_conv = JIVECore.Data.im2float(
                            img_original,
                            Symbol(${precision})
                        )
                
                        image_data[key] = img_conv
                        push!(image_keys, key)
                
                        println("Image stored as \\"$(key)\\" ")
                    end
                
                    global ${converted_key}
                    ${converted_key} = key
                end
                
                end
                nothing
                
            `);

            await resolveAfterTimeout(300);
        
            createMDCellWithUI(
                `$(@bind ${show_info} PlutoUI.CheckBox(default=false)) Show info of converted image`, ""
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
            if ${show_info} && !isnothing(${converted_key})
                JIVECore.Files.showInfo(image_data[${converted_key}])
            end
        `);

        
        }),

        createMenuItem("Convert to AxisArray Annotation", async function () {

            const sel_im = getVarName("axis_im");
            const axis_key = getVarName("axis_key");
            const axis_labels = getVarName("axis_labels");
        
            ////////////////////////////////////
            // UI
            ////////////////////////////////////
        
            createMDCellWithUI(
                "Convert Image to AxisArray",
                `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
        
Axis labels (comma separated):
$(@bind ${axis_labels} TextField(default="X,Y,Z,C"))
                `
            );
        
            await resolveAfterTimeout(300);
        
            ////////////////////////////////////
            // Processing
            ////////////////////////////////////
        
            createCellWithCode(`
        
                ${axis_key} = nothing
        
                let
        
                if !isnothing(${sel_im})
        
                    img = copy(image_data[${sel_im}])
        
                    # Parse axis labels
                    axes_tuple = Tuple(Symbol.(strip.(split(${axis_labels}, ","))))
        
                    axis_img = JIVECore.Data.im2axis(
                        img;
                        axes=axes_tuple
                    )
        
                    base_name = string(${sel_im}, "_axis")
        
                    key = JIVECore.Data.keyCheck(image_data, base_name)
                
                    image_data[key] = axis_img
        
                    if !(key in image_keys)
                        push!(image_keys, key)
                    end

                    println("Image stored as \\"$(key)\\" ")
                    println("Type: ", typeof(axis_img))
                    println("Dimensions: ", size(axis_img))
                    println("Axes: ", JIVECore.Data.axisnames(axis_img))
        
                    global ${axis_key}
                    ${axis_key} = key
        
                end
                end
        
                nothing
            `);
        
        }),

    ]

    const tableItems = [
        createMenuItem("Gray → LUT Mapping", async function () {

            const sel_im = getVarName("sel_im_lut");
            const scheme = getVarName("scheme_lut");
            const converted_key = getVarName("converted_key_lut");
        
            const lut_corner = getVarName("lut_corner");
            const lut_fontsize = getVarName("lut_fontsize");
        
            // ================= UI PANEL =================
        
            createMDCellWithUI(
                "Gray to LUT with colorbar",
                `
1. Select grayscale image  
$(@bind ${sel_im} Select([nothing, image_keys...]))
        
2. Color scheme  
$(@bind ${scheme} Select(["davos","viridis","magma","plasma","inferno","cividis","nuuk"]))
        
3. Colorbar position  $(@bind ${lut_corner} Select([:topleft,:topright,:bottomleft,:bottomright]))
        
4. Colorbar fontsize  
$(@bind ${lut_fontsize} Slider(0.01:0.001:0.1, default=0.03))
            `
            );
        
            await resolveAfterTimeout(300);
        
            // ================= CONVERSION CELL =================
        
            createCellWithCode(`
                ${converted_key} = nothing
                if !isnothing(${sel_im})
                
                let
                
                    local_base = string(${sel_im}, "_", ${scheme}, "_lut")
                
                    key = JIVECore.Data.keyCheck(image_data, local_base)
                
                    if !(key in image_keys)
                
                        img_orig_local = copy(image_data[${sel_im}])
                
                        img_conv_local = JIVECore.Data.gray2lut(
                            img_orig_local,
                            Symbol(${scheme})
                        )
                
                        image_data[key] = img_conv_local
                        push!(image_keys, key)
                
                        println("Image stored as \\"$(key)\\" ")
                
                    end
                
                    global ${converted_key}
                    ${converted_key} = key
                
                end
                
                end
                
                nothing
                `);
        
            await resolveAfterTimeout(300);
        
            // ================= VISUALIZATION CELL =================
        
            createCellWithCode(`
                if !isnothing(${converted_key})

                img_lut = copy(image_data[${converted_key}])

                    JIVECore.Draw.colorbar!(
                        img_lut,
                        corner=${lut_corner},
                        fontsize=${lut_fontsize},
                        scheme=Symbol(${scheme})
                    )
        
                end
                
                `);
        
        }),
    ]

    // Submenu channels
    const channelItems = [
        createMenuItem("Split Channels", async function () {
    
            const sel_im = getVarName("sel_im_split");
    
            createMDCellWithUI(
                "Split Image Channels",
                `
1. Select RGB or HSV image  
$(@bind ${sel_im} Select([nothing, image_keys...]))
                `
            );
    
            await resolveAfterTimeout(300);
            createCellWithCode(`
            
    let
    if !isnothing(${sel_im})
    
        img = copy(image_data[${sel_im}])
    
        chans = JIVECore.Data.separate_channels(img)
    
        if chans !== nothing
    
            # Detect color space name prefix
            prefix = ""
    
            if eltype(img) <: JIVECore.Visualize.ColorTypes.HSV
                prefix = "_HSV"
                channel_names = [:H,:S,:V]
            else
                prefix = "_RGB"
                channel_names = [:R,:G,:B]
            end
    
            for (i, field) in enumerate(keys(chans))
    
                channel_img = chans[field]
    
                base_key = string(${sel_im}, prefix, "_", channel_names[i])
    
                key = JIVECore.Data.keyCheck(image_data, base_key)
    
                image_data[key] = channel_img
    
                if !(key in image_keys)
                    push!(image_keys, key)
                end
    
                println("Channel stored as ", key)
    
            end
    
        end
    end
    end
    
    nothing
            `);
    
        }),
    
        createMenuItem("Merge Channels", async function () {

            const sel_im1 = getVarName("merge_im1");
            const sel_im2 = getVarName("merge_im2");
            const sel_im3 = getVarName("merge_im3");
        
            const ch1 = getVarName("merge_ch1");
            const ch2 = getVarName("merge_ch2");
            const ch3 = getVarName("merge_ch3");
        
            const merged_key = getVarName("merged_key");
            const show_merged = getVarName("show_merged");
        
            createMDCellWithUI(
                "Merge Gray Channels into RGB",
                `
### Channel 1
Image:
$(@bind ${sel_im1} Select([nothing, image_keys...]))
Assign to:
$(@bind ${ch1} Select([:r,:g,:b,:m,:y,:c,:gray]))
        
### Channel 2
Image:
$(@bind ${sel_im2} Select([nothing, image_keys...]))
Assign to:
$(@bind ${ch2} Select([:r,:g,:b,:m,:y,:c,:gray]))
        
### Channel 3
Image:
$(@bind ${sel_im3} Select([nothing, image_keys...]))
Assign to:
$(@bind ${ch3} Select([:r,:g,:b,:m,:y,:c,:gray]))
                `
            );
        
            await resolveAfterTimeout(300);
        
            // 🔹 Crear merge
            createCellWithCode(`
        ${merged_key} = nothing
        let
        if !isnothing(${sel_im1}) && !isnothing(${sel_im2}) && !isnothing(${sel_im3})
        
            img1 = copy(image_data[${sel_im1}])
            img2 = copy(image_data[${sel_im2}])
            img3 = copy(image_data[${sel_im3}])
        
            merged = JIVECore.Data.im2rgb(
                img1,
                img2,
                img3;
                channels=[${ch1}, ${ch2}, ${ch3}]
            )
        
            base_name = string("merge_", ${sel_im1}, "_", ${sel_im2}, "_", ${sel_im3})
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = merged
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            println("Merged image stored as ", key)
            
            global ${merged_key}
            ${merged_key} = key
        end
        end
        
        nothing
            `);
        
            await resolveAfterTimeout(300);
        
            // 🔹 Checkbox
            createMDCellWithUI(
`$(@bind ${show_merged} PlutoUI.CheckBox(default=false)) Show merged image`,""
            );
        
            await resolveAfterTimeout(300);
        
            // 🔹 Mostrar imagen
            createCellWithCode(`
        if ${show_merged} && !isnothing(${merged_key})
            JIVECore.Visualize.gif(
                JIVECore.Process.autoContrast(image_data[${merged_key}])
            )
        end
            `);
        
        }),
        createMenuItem("Extract Channel", function () {}),
    ]

    const NDTools = [
        createMenuItem("Maximum Intensity Projection", async function () {

            const sel_im     = getVarName("proj_im");
            const sel_dim    = getVarName("proj_dim");
            const sel_method = getVarName("proj_method");
            const proj_key   = getVarName("proj_key");
            const show_proj  = getVarName("show_proj");
        
            createMDCellWithUI(
                "Maximum Intensity Projection (ND Images)",
                `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
            
Method:
$(@bind ${sel_method} Select([:max, :mean, :sum, :std, :median], default=:max))
                `
            );

            await resolveAfterTimeout(300);

            createCellWithCode(`

                dims = if isnothing(${sel_im})
                    [1,2,3]
                else
                    current_img = image_data[${sel_im}]
                    current_img isa JIVECore.Data.AxisArray ?
                        collect(JIVECore.Data.axisnames(current_img)) :
                        collect(1:ndims(current_img))
                end
                
                md"""
                Projection dimension:
                $(@bind ${sel_dim} Select(dims))
                """
                
                `);
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
        
        ${proj_key} = nothing
        let
        if !isnothing(${sel_im}) && !isnothing(${sel_dim})
        
            img = image_data[${sel_im}]
        
            # 1 Projection (Symbol version)
            projected = JIVECore.Data.imProject(
                img,
                ${sel_dim};
                method=${sel_method}
            )
        
            # 4 Store
            base_name = string(${sel_im}, "_proj_", ${sel_method})
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = projected
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            global ${proj_key}
            ${proj_key} = key
            println("Projection stored as ", key)
        end
        end
        
        nothing
            `);
        
        }),
        createMenuItem("Merge", function () {}),
        createMenuItem("Insert Slice", function () {}),
        createMenuItem("Delete Slice", function () {}),
        createMenuItem("Join", function () {}),
    
    ]

    // Add accordions to menu
    accImage.appendChild(createAccordion("Types", typesItems, "Types"))
    accImage.appendChild(createAccordion("Lookup Tables", tableItems, "Lookup Tables"))
    accImage.appendChild(createAccordion("Channel Tools", channelItems, "Channel Tools"))
    accImage.appendChild(createAccordion("ND Tools", NDTools, "ND Tools"))
    // Add a line at the end
    const hr = document.createElement("hr")
    hr.style.margin = "12px 0 0 0"
    accImage.appendChild(hr)

    // Wrap button and menu
    const itemBarImage = document.createElement("div")
    itemBarImage.appendChild(accButtonImage)
    itemBarImage.appendChild(accImage)

    return itemBarImage
}
