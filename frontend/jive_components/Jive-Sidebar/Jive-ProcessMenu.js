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
    accContent.id = "AccProcess_" + idSuffix
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

export function createProcessMenu(timeoutValue) {
    // Main Process menu button
    const accButtonProcess = document.createElement("button")
    accButtonProcess.className = "jv-button jv-block jv-left-align"
    accButtonProcess.name = "Process"
    accButtonProcess.style.display = "flex"
    accButtonProcess.style.justifyContent = "space-between"
    accButtonProcess.style.alignItems = "center"
    accButtonProcess.innerHTML = `
        <span style="display:flex;align-items:center;">
            <span style="font-size:0.97em;">Process</span>
        </span>
        <img class="chevron" width="15" style="margin-left:auto;" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-down="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-up="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up-outline.svg">
    `
    accButtonProcess.onclick = function () {
        closeOtherAccordions(accProcess.id)
        myAccFunc(accProcess.id)
        updateAllChevrons()
    }

    // Main Process menu container
    const accProcess = document.createElement("div")
    accProcess.id = "AccProcess"
    accProcess.className = "jv-hide jv-card"
    accProcess.style.boxShadow = "none"
    accProcess.style.margin = "0px 0px 5px 15px"

    // 🧹 Filters
    const filterItems = [
        createMenuItem("Gaussian Blur", function () {}),
        createMenuItem("Median Filter", function () {}),
        createMenuItem("Bilateral Filter", function () {}),
        createMenuItem("Unsharp Mask", function () {}),
        createMenuItem("Edge Detection (Sobel, Canny)", function () {}),
    ]

    // 🧬 Morphology
    const morphItems = [
        createMenuItem("Erode", function () {}),
        createMenuItem("Dilate", function () {}),
        createMenuItem("Open", function () {}),
        createMenuItem("Close", function () {}),
        createMenuItem("Skeletonize", function () {}),

        createMenuItem("Distance Transform", async function () {

            const sel_im = getVarName("dist_im");
            const show_res = getVarName("dist_show");
            const dist_key = getVarName("dist_key");
        
            ////////////////////////////////////
            // UI PANEL
            ////////////////////////////////////
            createMDCellWithUI(
                "Distance Transform",
                `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
        
                `
            );
        
            await resolveAfterTimeout(300);
        
            ////////////////////////////////////
            // PROCESSING
            ////////////////////////////////////
            createCellWithCode(`
                ${dist_key} = nothing
        if !isnothing(${sel_im})
            let
                img = image_data[${sel_im}]
                dist = JIVECore.Process.distance_transform(JIVECore.Process.feature_transform(img))
                dist_norm = JIVECore.Data.Gray.((dist .+ minimum(dist)) ./ (maximum(dist) - minimum(dist)))
        
                base_name = "dist_" * string(${sel_im})
                key = JIVECore.Data.keyCheck(image_data, base_name)
                image_data[key] = dist_norm
        
                if !(key in image_keys)
                    push!(image_keys, key)
                end
        
                global ${dist_key}
                ${dist_key} = key
        
                println("Distance transform saved as: ", key)
            end
        end
            `);
            await resolveAfterTimeout(300);
            ////////////////////////////////////
            // SHOW RESULT
            ////////////////////////////////////
            createMDCellWithUI(
                `$(@bind ${show_res} PlutoUI.CheckBox(default=true)) Show Distance Transform Image`,
                ""
            );
        
            await resolveAfterTimeout(300);
        
            createCellWithCode(`
        if ${show_res} && !isnothing(${dist_key})
            JIVECore.Visualize.gif(image_data[${dist_key}])
        end
            `);
        }),

//////////////////////////
// 3️⃣ Find Maxima
//////////////////////////
createMenuItem("Find Maxima", async function () {

    const sel_im = getVarName("maxima_im");
    const sigma = getVarName("maxima_sigma");
    const min_dist = getVarName("maxima_min_dist");
    const threshold_rel = getVarName("maxima_thr");
    const exclude_border = getVarName("maxima_border");
    const maxima_key = getVarName("maxima_key");
    const show_overlay = getVarName("maxima_show");

    ////////////////////////////////////
    // UI PANEL
    ////////////////////////////////////
    createMDCellWithUI(
        "Find Maxima",
        `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Sigma: $(@bind ${sigma} Slider(0.1:0.1:10, default=1.5))
Min distance: $(@bind ${min_dist} Slider(1:1:50, default=11))
Relative threshold: $(@bind ${threshold_rel} Slider(0:0.01:1, default=0.4))
Exclude border: $(@bind ${exclude_border} PlutoUI.CheckBox(true))

        `
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // PROCESSING
    ////////////////////////////////////
    createCellWithCode(`
        ${maxima_key} = nothing
        if !isnothing(${sel_im})
            let
                img = image_data[${sel_im}]
                maxima_coords = JIVECore.Process.findPeaks(img, ${sigma}, ${min_dist}; 
                                    threshold_rel=${threshold_rel}, exclude_border=${exclude_border})
        
                # Generar nombre seguro usando keyCheck
                base_name = "maxima_" * ${sel_im}
                key = JIVECore.Data.keyCheck(image_data, base_name)
        
                global ${maxima_key}
                ${maxima_key} = key
        
                # Guardar overlay en diccionario
                image_data[key] = maxima_coords
        
                println("Maxima saved as: ", key)
            end
        end
            `);
    
    await resolveAfterTimeout(300);
    ////////////////////////////////////
    // VISUALIZATION
    ////////////////////////////////////
    createMDCellWithUI(
        `$(@bind ${show_overlay} PlutoUI.CheckBox(default=false)) Show Image`,
        ""
    );

    await resolveAfterTimeout(300);
    createCellWithCode(`
if ${show_overlay} && !isnothing(${sel_im}) && !isnothing(${maxima_key})
    img = image_data[${sel_im}]
    maxima = image_data[${maxima_key}]

    # Show image as heatmap
    JIVECore.Visualize.heatmap(JIVECore.Process.autoContrast(img); aspect_ratio=:equal, framestyle=:none, background_color=nothing, title="Find Maxima Overlay")
    JIVECore.Visualize.scatter!(
    [p[2] for p in maxima],
    [p[1] for p in maxima],
    color = :red,
    marker = :circle,
    markersize = 1,
    label = false
)
end
    `);

}),

    ]

    // 🔄 Transformations
    const transformItems = [
        createMenuItem("Rotate (90°, 180°, Arbitrary)", function () {}),
        createMenuItem("Flip (Horizontal/Vertical)", function () {}),
        createMenuItem("Crop", function () {}),
        createMenuItem("Resize", function () {}),
        createMenuItem("Translate", function () {}),
        createMenuItem("Perspective Warp", function () {}),
    ]

    // 🔊 Denoising
    const denoiseItems = [
        createMenuItem("Non-local Means", function () {}),
        createMenuItem("Wavelet Denoising", function () {}),
        createMenuItem("Anisotropic Diffusion", function () {}),
        createMenuItem("Total Variation Filter", function () {}),
    ]

    // 🔁 Deconvolution
    const deconvItems = [
        createMenuItem("Richardson-Lucy", async function () {
            const sel_im = getVarName("sel_im")
            const sel_psf = getVarName("sel_psf")
            const iterations = getVarName("iterations")
            const reg = getVarName("reg")
            createMDCellWithUI(
                "Richardson-Lucy Deconvolution",
                `
1. Select image to deconvolve: $(@bind ${sel_im} confirm(Select([nothing, image_keys...])))
1. Select psf: $(@bind ${sel_psf} confirm(Select([nothing, image_keys...]))) 
1. Select # of iterations: $(@bind ${iterations} confirm(NumberField(1:9999, default=1)))
1. Select regularizer: $(@bind ${reg} confirm(Select([nothing => "nothing"])))`
            )
            await resolveAfterTimeout(timeoutValue)
            createCellWithCode(`using FFTW`)
            await resolveAfterTimeout(timeoutValue)
            createCellWithCode(`
if isnothing(${sel_im}) 
    print("Select an image to deconvolve") 
elseif isnothing(${sel_psf}) 
    print("Select a PSF") 
else
    image_data[${sel_psf}*"_match"], _ = JIVECore.Process.imMatching(image_data[${sel_psf}], image_data[${sel_im}], method="replicate", collect_arrays=true);
    image_data[${sel_im}*"_dec"] = JIVECore.Process.deconvRL(JIVECore.Data.im2float(image_data[${sel_im}]), JIVECore.Data.im2float(ifftshift(image_data[${sel_psf}*"_match"])), regularizer=${reg}, iterations=${iterations});
    JIVECore.Visualize.gif(JIVECore.Process.autoContrast(image_data[${sel_im}*"_dec"]))
end`)
        }),
        createMenuItem("Wiener Deconvolution", function () {}),
        createMenuItem("PSF Estimation", function () {}),
        createMenuItem("Blind Deconvolution", function () {}),
    ]

    // Existing items
    const customItems = [
        createMenuItem("Apply Filter", function () {}),
        createMenuItem("Threshold", function () {}),


////////////////////////
// WATERSHED SEGMENTATION
////////////////////////

////////////////////////
// WATERSHED SEGMENTATION
////////////////////////

////////////////////////
// WATERSHED SEGMENTATION
////////////////////////

createMenuItem("Watershed Segmentation", async function () {

    const sel_im = getVarName("ws_im");
    const ws_thr_method = getVarName("ws_thr_method");
    const ws_thr_value = getVarName("ws_thr_value");
    const ws_clear_border = getVarName("ws_clear_border");
    const ws_apply_mask = getVarName("ws_apply_mask");
    const ws_size_filter_enable = getVarName("ws_size_filter_enable");
    const ws_size_filter = getVarName("ws_size_filter");
    const ws_key = getVarName("ws_key");
    const ws_show = getVarName("ws_show");
    const ws_slice = getVarName("ws_slice");
    const ws_dist_threshold = getVarName("ws_dist_threshold");

    // NUEVOS
    const ws_output_name = getVarName("ws_output_name");

    ////////////////////////////////////
    // UI PANEL
    ////////////////////////////////////

    createMDCellWithUI(
        "Watershed Segmentation",
        `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Output name:
$(@bind ${ws_output_name} TextField(default="watershed_result"))

Threshold method:
$(@bind ${ws_thr_method} Select(["otsu","manual"]))

Distance threshold:
$(@bind ${ws_dist_threshold} Slider(0:0.01:0.5, default=0.01, show_value=true))

Clear border:
$(@bind ${ws_clear_border} PlutoUI.CheckBox())

Apply mask:
$(@bind ${ws_apply_mask} PlutoUI.CheckBox())

Apply size filter:
$(@bind ${ws_size_filter_enable} PlutoUI.CheckBox())
`
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Dynamic controls
    ////////////////////////////////////

    createCellWithCode(`
if !isnothing(${sel_im})

    img_tmp = image_data[${sel_im}]

    if ndims(img_tmp) == 3

        md"""
        Slice (3D image):
        $(@bind ${ws_slice} Slider(1:size(img_tmp,3), show_value=true))
        """

    else
        nothing
    end

end
    `);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Manual threshold slider
    ////////////////////////////////////

    createCellWithCode(`
if ${ws_thr_method} == "manual"

    md"""
    Threshold value (manual only):
    $(@bind ${ws_thr_value} Slider(0:0.01:1, default=0.5, show_value=true))
    """

else
    nothing
end
    `);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Size filter slider
    ////////////////////////////////////

    createCellWithCode(`
if ${ws_size_filter_enable}

    md"""
    Object size filter (min/max):
    $(@bind ${ws_size_filter} PlutoUI.RangeSlider(0:10:500))
    """

else
    nothing
end
    `);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // PROCESSING + SAVE
    ////////////////////////////////////

    createCellWithCode(`

begin

    ${ws_key} = nothing

    if !isnothing(${sel_im})


        let

            key = isempty(${ws_output_name}) ? string(${sel_im}, "_ws") : ${ws_output_name}

            img_tmp = image_data[${sel_im}]

            img_orig_local = if ndims(img_tmp) == 3
                copy(img_tmp[:,:,${ws_slice}])
            else
                copy(img_tmp)
            end

            # -----------------------------
            # Apply watershed
            # -----------------------------
            if ${ws_size_filter_enable}

                img_ws, lbl_ws = JIVECore.Process.imWatershed(
                    img_orig_local,
                    [${ws_size_filter}[1], ${ws_size_filter}[end]];
                    threshold = ${ws_thr_method} == "manual" ? ${ws_thr_value} : nothing,
                    dist_threshold=${ws_dist_threshold},
                    clear_border=${ws_clear_border},
                )

            else

                img_ws, lbl_ws = JIVECore.Process.imWatershed(
                    img_orig_local;
                    threshold = ${ws_thr_method} == "manual" ? ${ws_thr_value} : nothing,
                    dist_threshold=${ws_dist_threshold},
                    clear_border=${ws_clear_border},
                    apply_mask=${ws_apply_mask}
                )

            end

            # -----------------------------
            # Store image
            # -----------------------------
            image_data[key] = img_ws

            if !(key in image_keys)
                push!(image_keys, key)
            end

            global ${ws_key}
            ${ws_key} = key

            println("Image stored as \\"$(key)\\" ")

        end

    end

end

nothing
    `);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Visualization checkbox
    ////////////////////////////////////

    createMDCellWithUI(
        `$(@bind ${ws_show} PlutoUI.CheckBox()) Show Watershed image`,
        ""
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Visualization
    ////////////////////////////////////

    createCellWithCode(`

if ${ws_show} && !isnothing(${ws_key}) && haskey(image_data, ${ws_key})

    img_water = copy(image_data[${ws_key}])

    JIVECore.Visualize.gif(img_water)

end

    `);

}),

        createMenuItem("Normalize", function () {}),


////////////////////////
// CONVERT TO BW
////////////////////////

createMenuItem("Convert to BW", async function () {

    const sel_im = getVarName("bw_im");
    const method = getVarName("bw_method");
    const threshold = getVarName("bw_thr");

    const converted_key = getVarName("bw_key");
    const show_bw = getVarName("bw_show");

    ////////////////////////////////////
    // UI
    ////////////////////////////////////

    createMDCellWithUI(
        "Convert Image to Black & White",
        `
Select image  
$(@bind ${sel_im} Select([nothing, image_keys...]))

Threshold method  
$(@bind ${method} Select(["otsu","manual"]))

Manual threshold  
$(@bind ${threshold} Slider(0:0.01:1, default=0.5))
        `
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Processing
    ////////////////////////////////////

    createCellWithCode(`

${converted_key} = nothing

if !isnothing(${sel_im})

let

    local_base = string(${sel_im}, "_bw")

    key = string(${sel_im}, "_bw")

    img_orig_local = copy(image_data[${sel_im}])

    if ${method} == "manual"
        img_bw_local = JIVECore.Process.im2BW(img_orig_local, ${threshold})
    else
        img_bw_local = JIVECore.Process.im2BW(img_orig_local)
    end

    image_data[key] = img_bw_local

    if !(key in image_keys)
        push!(image_keys, key)
    end

    global ${converted_key}
    ${converted_key} = key
    println("Image stored as \\"$(key)\\" ")

end

end

nothing


`);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Visualization
    ////////////////////////////////////

    createMDCellWithUI(
        `$(@bind ${show_bw} PlutoUI.CheckBox(false)) Show BW image`,
        ""
    );

    await resolveAfterTimeout(300);

    createCellWithCode(`

if ${show_bw} && !isnothing(${converted_key})

img_bw = copy(image_data[${converted_key}])

JIVECore.Visualize.gif(img_bw)

end

`);

}),
        createMenuItem("Calculate Images", async function () {

            const sel_img1 = getVarName("calc_img1");
            const sel_img2 = getVarName("calc_img2");
        
            const sel_c1 = getVarName("calc_c1");
            const sel_c2 = getVarName("calc_c2");
        
            const sel_op = getVarName("calc_op");
            const rem_neg = getVarName("calc_remove_neg");
        
            const calc_key = getVarName("calc_key");
        
            ////////////////////////////////////
            // UI
            ////////////////////////////////////
        
            createMDCellWithUI(
                "Image Calculation",
                `
Image 1:
$(@bind ${sel_img1} Select([nothing, image_keys...]))
        
Channel img1:
$(@bind ${sel_c1} NumberField(1:10, default=1))
        
Image 2:
$(@bind ${sel_img2} Select([nothing, image_keys...]))
        
Channel img2:
$(@bind ${sel_c2} NumberField(1:10, default=1))
        
Operation:
$(@bind ${sel_op} Select(["+", "-", "*", "/"]))
        
Remove negatives:
$(@bind ${rem_neg} CheckBox(default=false))
                `
            );
        
            await resolveAfterTimeout(300);
        
            ////////////////////////////////////
            // Processing
            ////////////////////////////////////
        
            createCellWithCode(`
        
        ${calc_key} = nothing
        
        let
        
        if !isnothing(${sel_img1}) && !isnothing(${sel_img2})
        
            img1_full = image_data[${sel_img1}]
            img2_full = image_data[${sel_img2}]
        
            # --- detectar canal en img1 ---
            if img1_full isa JIVECore.Data.AxisArray && :c in JIVECore.Data.axisnames(img1_full)
                img1 = img1_full[c=${sel_c1}]
            else
                img1 = img1_full
            end
        
            # --- detectar canal en img2 ---
            if img2_full isa JIVECore.Data.AxisArray && :c in JIVECore.Data.axisnames(img2_full)
                img2 = img2_full[c=${sel_c2}]
            else
                img2 = img2_full
            end
        
            # --- operación ---
            if ${sel_op} == "+"
                op = +
            elseif ${sel_op} == "-"
                op = -
            elseif ${sel_op} == "*"
                op = *
            else
                op = /
            end
        
            result = JIVECore.Data.imCalculate(
                img1,
                img2,
                op;
                remove_negatives=${rem_neg}
            )
        
            base_name = string(${sel_img1}, "_", ${sel_op}, "_", ${sel_img2})
        
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = result
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            global ${calc_key}
            ${calc_key} = key
        
            println("Stored image: ", key)
            println("Size: ", size(result))
        
        end
        
        end
        
        nothing
        
        `);
        
        }),
    ]

    // Add accordions to menu
    accProcess.appendChild(createAccordion("🧹 Filters", filterItems, "filters"))
    accProcess.appendChild(createAccordion("🧬 Morphology", morphItems, "morphology"))
    accProcess.appendChild(createAccordion("🔄 Transformations", transformItems, "transform"))
    accProcess.appendChild(createAccordion("🔊 Denoising", denoiseItems, "denoise"))
    accProcess.appendChild(createAccordion("🔁 Deconvolution", deconvItems, "deconv"))
    accProcess.appendChild(createAccordion("Custom", customItems, "custom"))

    // Add a line at the end
    const hr = document.createElement("hr")
    hr.style.margin = "12px 0 0 0"
    accProcess.appendChild(hr)

    // Wrap button and menu
    const itemBarProcess = document.createElement("div")
    itemBarProcess.appendChild(accButtonProcess)
    itemBarProcess.appendChild(accProcess)

    return itemBarProcess
}
