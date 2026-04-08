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
    accContent.id = "AccMeasure_" + idSuffix
    accContent.className = "jv-hide jv-card"
    accContent.style.boxShadow = "none"
    accContent.style.margin = "0px 0px 5px 15px"
    accContent.style.fontSize = "0.92em"

    items.forEach((item) => accContent.appendChild(item))

    accButton.onclick = function () {
        closeOtherAccordions(accContent.id)
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

export function createMeasureMenu(timeoutValue) {
    // Main Measurements menu button
    const accButtonMeasure = document.createElement("button")
    accButtonMeasure.className = "jv-button jv-block jv-left-align"
    accButtonMeasure.name = "Measurements"
    accButtonMeasure.style.display = "flex"
    accButtonMeasure.style.justifyContent = "space-between"
    accButtonMeasure.style.alignItems = "center"
    accButtonMeasure.innerHTML = `
        <span style="display:flex;align-items:center;">
            <span style="font-size:0.97em;">Measure </span>
        </span>
        <img class="chevron" width="15" style="margin-left:auto;" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-down="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down-outline.svg"
            data-up="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up-outline.svg">
    `
    accButtonMeasure.onclick = function () {
        closeOtherAccordions(accMeasure.id, "AccMeasure_")
        myAccFunc(accMeasure.id)
        updateAllChevrons()
    }

    // Main Measurements menu container
    const accMeasure = document.createElement("div")
    accMeasure.id = "AccMeasure"
    accMeasure.className = "jv-hide jv-card"
    accMeasure.style.boxShadow = "none"
    accMeasure.style.margin = "0px 0px 5px 15px"

    // 📈 Intensity & Stats
    const intensityItems = [

////////////////////////
// MEASURE IMAGE
////////////////////////
createMenuItem("Measure Image", async function () {

    const sel_im = getVarName("measure_im");

    createMDCellWithUI(
        "Measure Image",
        `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
        `
    );

    await resolveAfterTimeout(300);

    createCellWithCode(`

let

global results_table

if !isnothing(${sel_im})

    img = image_data[${sel_im}]

    if isnothing(results_table[])
        results_table[] = JIVECore.Analyze.stats_table(img)
    else
        results_table[] = JIVECore.Analyze.stats_table(img, df=results_table[])
    end

end

results_table[]

end

`);

}),

////////////////////////
// MEASURE WITH THRESHOLD
////////////////////////

createMenuItem("Measure with Threshold", async function () {

    const sel_im = getVarName("measure_thr_im");
    const threshold = getVarName("measure_thr_method");

    createMDCellWithUI(
        "Measure with Threshold",
        `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Threshold:
$(@bind ${threshold} Select(["auto","otsu"]))
        `
    );

    await resolveAfterTimeout(300);

    createCellWithCode(`

let

global results_table

if !isnothing(${sel_im})

    img = image_data[${sel_im}]

    if isnothing(results_table[])
        results_table[] = JIVECore.Analyze.stats_table(img, threshold=${threshold})
    else
        results_table[] = JIVECore.Analyze.stats_table(img, threshold=${threshold}, df=results_table[])
    end

end

results_table[]

end

`);

}),

////////////////////////
// ANALYZE PARTICLES
////////////////////////

createMenuItem("Analyze Particles", async function () {

    const label_im = getVarName("label_image");
    const intensity_im = getVarName("intensity_image");
    const df_part = getVarName("df_paricles");
    const stats_sel = getVarName("stats_selection");

    createMDCellWithUI(
        "Analyze Particles",
        `
Label image:
$(@bind ${label_im} Select([nothing, image_keys...]))

Intensity image (optional):
$(@bind ${intensity_im} Select([nothing, image_keys...]))

Statistics:
$(@bind ${stats_sel} MultiSelect([
:count,
:centroid,
:bbox,
:aspect_ratio,
:perimeter,
:circularity,
:roundness,
:major_axis,
:minor_axis,
:angle,
:eccentricity,
:mean,
:std,
:min,
:max,
:area
]))
        `
    );

    await resolveAfterTimeout(300);

    createCellWithCode(`
if !isnothing(${label_im})
    let 

        labels = image_data[${label_im}]
       
        stats = Symbol.(${stats_sel})

        if isnothing(${intensity_im})

                df = JIVECore.Analyze.region_stats(labels; stats=stats)

        else

            img = image_data[${intensity_im}]
            df = JIVECore.Analyze.region_stats(labels, img; stats=stats)

        end
        df
    end
end
    `);

}),

////////////////////////
// IMAGE HISTOGRAM    //
////////////////////////

createMenuItem("Show Image Histogram", async function () {

    const sel_im = getVarName("hist_im");
    const plot_norm = getVarName("hist_norm");
    const plot_edges = getVarName("hist_edges");

    ////////////////////////////////////
    // UI CELL
    ////////////////////////////////////

    createMDCellWithUI(
        "Image Histogram",
        `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Normalize counts:
$(@bind ${plot_norm} PlutoUI.CheckBox(false))

Normalize edges (0-1):
$(@bind ${plot_edges} PlutoUI.CheckBox(false))
        `
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // Processing
    ////////////////////////////////////

    createCellWithCode(`

let

    if !isnothing(${sel_im})

        img = image_data[${sel_im}]
        
        # Si es AxisArray usamos .data
        img_data = img isa JIVECore.Data.AxisArray ? img.data : img

        # Detecta tipo de imagen
        is_rgb = img_data isa JIVECore.Data.AbstractArray{<:JIVECore.Visualize.ColorTypes.RGB}

        # Calcula histograma
        if is_rgb
            edges, counts = JIVECore.Process.imHistogram(img_data, 8; normalize=${plot_norm}, normalize_edges=${plot_edges})
        else
            edges, counts = JIVECore.Process.imHistogram(img_data, 8; normalize=${plot_norm}, normalize_edges=${plot_edges})
        end

        # Mostrar histograma
        plt =JIVECore.Visualize.showHist(edges, counts)

    end

end # let

    `);

}),


////////////////////////
// PIXEL STATISTICS
////////////////////////

            createMenuItem("Pixel Statistics", async function () {

                const sel_im = getVarName("pixel_stats_im");

                createMDCellWithUI(
                    "Pixel Statistics",
                    `
Select image:
$(@bind ${sel_im} Select([nothing, image_keys...]))
                    `
                );

                await resolveAfterTimeout(300);

                createCellWithCode(`

            let

                if !isnothing(${sel_im})

                    img = image_data[${sel_im}]

                    df = JIVECore.Analyze.array_statistics(img; stats=[:mean,:std,:min,:max])

                    df

                end

            end

            `);

}),

createMenuItem("Show Distribution", async function () {

    const vis_df = getVarName("vis_df");
    const vis_col = getVarName("vis_col");
    const vis_fit = getVarName("vis_fit");

    //////////////////////////////
    // UI
    //////////////////////////////

    createMDCellWithUI(
        "Show Distribution",
        `
Select DataFrame:
$(@bind ${vis_df} Select([nothing, df_keys...]))

Fit distribution:
$(@bind ${vis_fit} Select([nothing, "Normal", "LogNormal", "Gamma"]))
        `
    );

    await resolveAfterTimeout(300);

    //////////////////////////////
    // Column selector
    //////////////////////////////

    createCellWithCode(`
if !isnothing(${vis_df})

    df_local = ${vis_df}

    md"""
Column:
$(@bind ${vis_col} Select(names(df_local)))
"""

end
`);

    await resolveAfterTimeout(300);

    //////////////////////////////
    // Plot
    //////////////////////////////

    createCellWithCode(`
if !isnothing(${vis_df}) && !isnothing(${vis_col})

    df_local = ${vis_df}

    fit_map = Dict(
        "Normal" => Normal,
        "LogNormal" => LogNormal,
        "Gamma" => Gamma
    )

    fit_dist = haskey(fit_map, ${vis_fit}) ? fit_map[${vis_fit}] : nothing

    JIVECore.Visualize.showDist(
        df_local.${vis_col};
        fit_dist=fit_dist
    )

end
`);

}),
    ]

    // 🔵 Shape Analysis
    const shapeItems = [
        createMenuItem("Area", function () {}),
        createMenuItem("Perimeter", function () {}),
        createMenuItem("Circularity", function () {}),
        createMenuItem("Eccentricity", function () {}),
        createMenuItem("Feret Diameter", function () {}),
    ]

    // 🔢 Object Detection
    const objectItems = [
        createMenuItem("Count Particles", function () {}),

//////////////////////////
// 2️⃣ Label Components
//////////////////////////
createMenuItem("Label Components", async function () {

    const sel_im = getVarName("label_dt_im");
    const dist_threshold = getVarName("label_dist_threshold");
    const lbl_key = getVarName("lbl_key");

    ////////////////////////////////////
    // UI PANEL
    ////////////////////////////////////
    createMDCellWithUI(
        "Label Components",
        `
Select distance transform image:
$(@bind ${sel_im} Select([nothing, image_keys...]))

Distance threshold:
$(@bind ${dist_threshold} Slider(-5:0.1:5, default=0.1, show_value=true))
        `
    );

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // PROCESSING
    ////////////////////////////////////
    createCellWithCode(`
        ${lbl_key} = nothing
if !isnothing(${sel_im})
    let
        dist_img = image_data[${sel_im}]
        markers = JIVECore.Process.label_components(dist_img .< ${dist_threshold})

        # Normalizar y convertir a Gray
        out = JIVECore.Data.Gray.(markers ./ 10)

        # Guardar imagen en image_data con keyCheck
        key = JIVECore.Data.keyCheck(image_data, "markers_" * ${sel_im})

        image_data[key] = out
        if !(key in image_keys)
            push!(image_keys, key)
        end

        # Variable global para UI
        global ${lbl_key}
        ${lbl_key} = key

        println("Labeled components saved as: ", key)

    end
end
`);

    await resolveAfterTimeout(300);

    ////////////////////////////////////
    // VISUALIZATION
    ////////////////////////////////////
    createCellWithCode(`
if !isnothing(${lbl_key})
    img_lbl = image_data[${lbl_key}]
    JIVECore.Data.Gray.(img_lbl)
end
`);
}),
        createMenuItem("Bounding Boxes", function () {}),
        createMenuItem("Centroid Detection", function () {}),
        createMenuItem("Object Table Export", function () {}),
    ]

    // ⏱️ Time-Series
    const timeItems = [
        createMenuItem("Intensity vs Time", function () {}),
        createMenuItem("Kymograph", function () {}),
        createMenuItem("Track Movement", function () {}),
        createMenuItem("Object Lifecycle", function () {}),
    ]

    // 🎯 Colocalization
    const colocalItems = [
        createMenuItem("Pearson Coefficient", function () {}),
        createMenuItem("Manders’ Coefficient", function () {}),
        createMenuItem("Overlap Fraction", function () {}),
        createMenuItem("Scatter Plot", function () {}),
    ]

    // 📏 Profiles & ROIs
    const roiItems = [
            // 📈 Profiles & Plots
        createMenuItem("Line Profile", async function () {
            const sel_im = getVarName("sel_im")
            const x1 = getVarName("x1")
            const y1 = getVarName("y1")
            const x2 = getVarName("x2")
            const y2 = getVarName("y2")
            
            createMDCellWithUI(
                "Line Intensity Profile",
                `
1. Select image: $(@bind ${sel_im} Select([nothing, image_keys...]))
2. Start X: $(@bind ${x1} NumberField(1:10000, default=100))
3. Start Y: $(@bind ${y1} NumberField(1:10000, default=100))
4. End X: $(@bind ${x2} NumberField(1:10000, default=200))
5. End Y: $(@bind ${y2} NumberField(1:10000, default=200))
            `
            )
        
            await resolveAfterTimeout(timeoutValue * 2)
    
            createCellWithCode(`
if isnothing(${sel_im})
    print("Select an image")
else
    JIVECore.Visualize.plotLine(image_data[${sel_im}],(${x1}, ${y1}),(${x2}, ${y2}),legend=true)
end`)

            await resolveAfterTimeout(timeoutValue * 2)

            createCellWithCode(`
if !isnothing(${sel_im})
    img = image_data[${sel_im}]
    img_line = copy(img)
    
    JIVECore.Visualize.gif(JIVECore.Draw.draw_line(img_line,(${x1}, ${y1}),(${x2}, ${y2}),5,value=1))
    
end`) 
        }),
    

        createMenuItem("Radial Profile", function () {}),
        createMenuItem("ROI Measurements", function () {}),
        createMenuItem("Multi-ROI Table", function () {}),
    ]

    // 📤 Export
    const exportItems = [
        createMenuItem("Export Measurements Table", function () {}),
        createMenuItem("CSV / Excel / DataFrame", function () {}),
        createMenuItem("Save Plots", function () {}),
    ]

    // Add accordions to menu
    accMeasure.appendChild(createAccordion("📈 Stats", intensityItems, "stats"))
    accMeasure.appendChild(createAccordion("🔵 Shape Analysis", shapeItems, "shape"))
    accMeasure.appendChild(createAccordion("🔢 Object Detection", objectItems, "object"))
    accMeasure.appendChild(createAccordion("⏱️ Time-Series", timeItems, "time"))
    accMeasure.appendChild(createAccordion("🎯 Colocalization", colocalItems, "colocal"))
    accMeasure.appendChild(createAccordion("📏 Profiles & ROIs", roiItems, "roi"))
    accMeasure.appendChild(createAccordion("📤 Export", exportItems, "export"))

    // Add a line at the end
    const hr = document.createElement("hr")
    hr.style.margin = "12px 0 0 0"
    accMeasure.appendChild(hr)

    // Wrap button and menu
    const itemBarMeasure = document.createElement("div")
    itemBarMeasure.appendChild(accButtonMeasure)
    itemBarMeasure.appendChild(accMeasure)

    return itemBarMeasure
}
