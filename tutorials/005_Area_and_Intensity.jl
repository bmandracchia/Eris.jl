### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ d0751315-644f-436d-a92a-2d37ac91cab6
md"""
##### Load Image
$(@bind tmp1776675215532 PlutoUI.FilePicker())
"""


# ╔═╡ 7a1c2628-8690-41d0-97a7-998695c1bf7d

            loaded_index1776675215532 = isnothing(tmp1776675215532) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1776675215532)
                nothing
            


# ╔═╡ e978ebb6-277c-4aa0-8e3c-8f465e2dc7ae
md"""
##### $(@bind show_image1776675215532 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ ba2a1bc3-de20-4ac3-8daf-3a2ce2eeee3a

            if show_image1776675215532 && !isnothing(loaded_index1776675215532)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1776675215532])
                )
    
            end
            


# ╔═╡ a435f9d2-0a3a-4bfc-b259-c75bb12aa502
md"""
##### $(@bind show_info1776675215532 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ a6a5356e-a722-44ab-b9be-35d0bafadf95

            if show_info1776675215532 && !isnothing(loaded_index1776675215532)
                JIVECore.Files.showInfo(image_data[loaded_index1776675215532])
            end
            


# ╔═╡ 379e145d-cfb8-4d54-af92-09bf99803562
md"""
# 🧪 Split Channels

This section allows you to **separate an RGB or HSV image into its individual channels**.

**Steps to use it:**

1. **Select the image**  
   Choose an RGB or HSV image to split into channels:  
   $(@bind sel_im_split Select([nothing, image_keys...]))

2. **Split channels**  
   The system automatically separates the image into its individual components:
   - RGB → R, G, B  
   - HSV → H, S, V  

3. **Store results**  
   Each channel is stored as a separate image in `image_data`.

   The output names follow this format:
   - `original_RGB_R`, `original_RGB_G`, `original_RGB_B`  
   - `original_HSV_H`, `original_HSV_S`, `original_HSV_V`

4. **Use separated channels**  
   The resulting images can be used for further processing such as:
   - intensity analysis  
   - channel merging  
   - visualization or filtering  

> 💡 Tip: Splitting channels is useful for analyzing individual color components or preparing data for custom RGB compositions.
"""

# ╔═╡ 9b26a69a-a065-4643-9938-aa5118b87e94
md"""
##### Split Image Channels

1. Select RGB or HSV image  
$(@bind sel_im_split1776675367878 Select([nothing, image_keys...]))
                
"""


# ╔═╡ 8ce81514-baeb-4184-a203-550a55c0a9b8

            
    let
    if !isnothing(sel_im_split1776675367878)
    
        img = copy(image_data[sel_im_split1776675367878])
    
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
    
                base_key = string(sel_im_split1776675367878, prefix, "_", channel_names[i])
    
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
            


# ╔═╡ d8dabb38-fcdb-4bac-b6bc-940be20eb042
md"""
##### Mosaic Image Viewer

Images to display:
$(@bind mosaic_imgs1776675378686 MultiSelect(image_keys))
        
Times to display (per image, 0-indexed):
$(@bind mosaic_times1776675378686 MultiSelect(0:49))
        
Rows:
$(@bind mosaic_nrow1776675378686 NumberField(1:10, default=1))
        
Columns:
$(@bind mosaic_ncol1776675378686 NumberField(1:10, default=1))
                    
"""


# ╔═╡ 559e2275-72de-49fb-9549-d335d2d5a9dd

        let
        
        if !isnothing(mosaic_imgs1776675378686) && length(mosaic_imgs1776675378686) > 0
        
            # Extraer imágenes seleccionadas
            imgs = map(k -> image_data[k], mosaic_imgs1776675378686)
        
            # Si hay selección de tiempos, tomar solo esos frames
            imgs = map(img -> begin
                if !isnothing(mosaic_times1776675378686) && length(mosaic_times1776675378686) > 0
                    # img[:, :, sel_times .+ 1]  # Julia es 1-indexed
                    img[:, :, mosaic_times1776675378686 .+ 1]
                else
                    img
                end
            end, imgs)
        
            println("Displaying mosaic with ", length(imgs), " images, ", length(mosaic_times1776675378686), " frames per image")
        
            JIVECore.Visualize.mosaicview(
                imgs...;
                nrow=mosaic_nrow1776675378686,
                ncol=mosaic_ncol1776675378686
            )
        
        end
        
        end
                


# ╔═╡ 5609c55a-d19e-4f45-a7f9-150eb20ba614
md"""
# 📊 Image Histogram

This section allows you to **visualize the intensity distribution of an image** using a histogram.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to analyze:  
   $(@bind hist_im Select([nothing, image_keys...]))

2. **Normalize counts (optional)**  
   Normalize the histogram values so they represent relative frequencies:  
   $(@bind hist_norm PlutoUI.CheckBox(false))

3. **Normalize edges (optional)**  
   Scale intensity values to the range [0–1]:  
   $(@bind hist_edges PlutoUI.CheckBox(false))

4. **Generate histogram**  
   The system computes and displays the histogram of the image.

   - For grayscale images: intensity distribution is shown directly  
   - For RGB images: histogram is computed across color channels  

5. **Interpret results**  
   The histogram shows how pixel intensities are distributed, which helps with:
   - contrast analysis  
   - exposure evaluation  
   - preprocessing decisions (e.g., thresholding)

> 💡 Tip: Use normalized histograms to compare images with different intensity ranges or bit depths.
"""

# ╔═╡ 783a9bc6-91df-4972-8582-d9f7c1b81438
md"""
##### Image Histogram

Select image:
$(@bind hist_im1776675648101 Select([nothing, image_keys...]))

Normalize counts:
$(@bind hist_norm1776675648101 PlutoUI.CheckBox(false))

Normalize edges (0-1):
$(@bind hist_edges1776675648101 PlutoUI.CheckBox(false))
        
"""


# ╔═╡ 4be3a19f-05b3-47bd-938f-c2ed6f737d5d


let

    if !isnothing(hist_im1776675648101)

        img = image_data[hist_im1776675648101]
        
        # Si es AxisArray usamos .data
        img_data = img isa JIVECore.Data.AxisArray ? img.data : img

        # Detecta tipo de imagen
        is_rgb = img_data isa JIVECore.Data.AbstractArray{<:JIVECore.Visualize.ColorTypes.RGB}

        # Calcula histograma
        if is_rgb
            edges, counts = JIVECore.Process.imHistogram(img_data, 8; normalize=hist_norm1776675648101, normalize_edges=hist_edges1776675648101)
        else
            edges, counts = JIVECore.Process.imHistogram(img_data, 8; normalize=hist_norm1776675648101, normalize_edges=hist_edges1776675648101)
        end

        # Mostrar histograma
        plt =JIVECore.Visualize.showHist(edges, counts)

    end

end # let

    


# ╔═╡ a70d184b-336f-4865-80f6-9da18597b335
md"""
# ⚫ Convert to Black & White

This section allows you to **convert an image into a binary (black & white) representation** using thresholding.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to convert:  
   $(@bind bw_im Select([nothing, image_keys...]))

2. **Select threshold method**  
   Choose how the threshold is computed:
   $(@bind bw_method Select(["otsu","manual"]))

   - `otsu`: automatic threshold based on image histogram  
   - `manual`: user-defined threshold  

3. **Set manual threshold (optional)**  
   If using manual mode, adjust the threshold value:  
   $(@bind bw_thr Slider(0:0.01:1, default=0.5))

4. **Convert image**  
   The image is converted into a binary image:
   - pixels above threshold → white  
   - pixels below threshold → black  

   The result is stored in `image_data` with a name like:
   `original_name_bw`

5. **Display result (optional)**  
   You can visualize the binary image by enabling:
   $(@bind bw_show PlutoUI.CheckBox(false))

> 💡 Tip: Use Otsu for automatic segmentation, and manual thresholding when you need precise control over object detection.
"""

# ╔═╡ f01f6e8d-00a4-477f-8a8c-199c21d62ebe
md"""
##### Convert Image to Black & White

Select image  
$(@bind bw_im1776675707960 Select([nothing, image_keys...]))

Threshold method  
$(@bind bw_method1776675707960 Select(["otsu","manual"]))

Manual threshold  
$(@bind bw_thr1776675707960 Slider(0:0.01:1, default=0.5))
        
"""


# ╔═╡ 30e02c1d-2769-49a2-8522-923e5e513ee8


bw_key1776675707960 = nothing

if !isnothing(bw_im1776675707960)

let

    local_base = string(bw_im1776675707960, "_bw")

    key = string(bw_im1776675707960, "_bw")

    img_orig_local = copy(image_data[bw_im1776675707960])

    if bw_method1776675707960 == "manual"
        img_bw_local = JIVECore.Process.im2BW(img_orig_local, bw_thr1776675707960)
    else
        img_bw_local = JIVECore.Process.im2BW(img_orig_local)
    end

    image_data[key] = img_bw_local

    if !(key in image_keys)
        push!(image_keys, key)
    end

    global bw_key1776675707960
    bw_key1776675707960 = key
    println("Image stored as \"$(key)\" ")

end

end

nothing




# ╔═╡ 06fea810-202a-45f3-a61b-b29a2070b419
md"""
##### $(@bind bw_show1776675707960 PlutoUI.CheckBox(false)) Show BW image

"""


# ╔═╡ f31bbd2e-1617-46e7-96f7-1a3c783d6063


if bw_show1776675707960 && !isnothing(bw_key1776675707960)

img_bw = copy(image_data[bw_key1776675707960])

JIVECore.Visualize.gif(img_bw)

end



# ╔═╡ 0c531528-f569-4c76-8728-a57ea2df3ea5
md"---"

# ╔═╡ 2733c0f2-3c3b-46fe-85b9-16a01ce1cd4c
md"""
##### Convert Image to AxisArray

Select image:
$(@bind axis_im1776676119225 Select([nothing, image_keys...]))
        
Axis labels (comma separated):
$(@bind axis_labels1776676119225 TextField(default="X,Y,Z,C"))
                
"""


# ╔═╡ eea2e62f-7088-48d3-a5c4-7baadd572d8e

        
                axis_key1776676119225 = nothing
        
                let
        
                if !isnothing(axis_im1776676119225)
        
                    img = copy(image_data[axis_im1776676119225])
        
                    # Parse axis labels
                    axes_tuple = Tuple(Symbol.(strip.(split(axis_labels1776676119225, ","))))
        
                    axis_img = JIVECore.Data.im2axis(
                        img;
                        axes=axes_tuple
                    )
        
                    base_name = string(axis_im1776676119225, "_axis")
        
                    key = JIVECore.Data.keyCheck(image_data, base_name)
                
                    image_data[key] = axis_img
        
                    if !(key in image_keys)
                        push!(image_keys, key)
                    end

                    println("Image stored as \"$(key)\" ")
                    println("Type: ", typeof(axis_img))
                    println("Dimensions: ", size(axis_img))
                    println("Axes: ", JIVECore.Data.axisnames(axis_img))
        
                    global axis_key1776676119225
                    axis_key1776676119225 = key
        
                end
                end
        
                nothing
            


# ╔═╡ 216dd0ba-3a38-434a-afc8-99b16cd9a266
md"""
##### Calibrate Parameters

1. Select Image
$(@bind sel_im1776676377706 Select([nothing, image_keys...]))
            
2. Choose axes to calibrate:
Horizontal $(@bind calibrate_h1776676377706 PlutoUI.CheckBox(true))
Vertical   $(@bind calibrate_v1776676377706 PlutoUI.CheckBox())
Time      $(@bind calibrate_t1776676377706 PlutoUI.CheckBox())
            
Horizontal value: $(@bind h_val1776676377706 NumberField(0:0.001:10, default=0.001))
Horizontal unit: $(@bind h_unit1776676377706 Select(["mm", "μm"]))
            
Vertical value: $(@bind v_val1776676377706 NumberField(0:0.1:10, default=1))
Vertical unit: $(@bind v_unit1776676377706 Select(["mm", "μm"]))
            
Time value: $(@bind t_val1776676377706 NumberField(0:1:100, default=1))
Time unit: $(@bind t_unit1776676377706 Select(["s", "ms"]))
                    
"""


# ╔═╡ fbae27f2-cfe9-4333-905b-d708d1da8509

            using Unitful

            calibrated_key1776676377706 = nothing

            if !isnothing(sel_im1776676377706)

                img = image_data[sel_im1776676377706]

                # Obtener los nombres de los ejes de la imagen
                axes_names = JIVECore.Data.axisnames(img)
                dims = length(axes_names)

                # Crear diccionario de spacings por defecto = 1
                spacings = Dict{Symbol,Any}()
                for ax in axes_names
                    spacings[ax] = 1
                end

                # Reemplazar solo los ejes que el usuario seleccionó
                if calibrate_h1776676377706 && dims >= 1
                    spacings[axes_names[1]] = h_val1776676377706 * (h_unit1776676377706 == "mm" ? Unitful.mm : Unitful.μm)
                end

                if calibrate_v1776676377706 && dims >= 2
                    spacings[axes_names[2]] = v_val1776676377706 * (v_unit1776676377706 == "mm" ? Unitful.mm : Unitful.μm)
                end

                if calibrate_t1776676377706 && dims >= 3
                    spacings[axes_names[3]] = t_val1776676377706 * (t_unit1776676377706 == "s" ? Unitful.s : Unitful.ms)
                end

                # Calibrar imagen con todos los ejes
                img2 = JIVECore.Data.imCalibrate(img; spacings...)

                # Guardar imagen calibrada en el diccionario con keyCheck
                key = JIVECore.Data.keyCheck(image_data, string(sel_im1776676377706, "_calibrated"))
                image_data[key] = img2

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global calibrated_key1776676377706
                calibrated_key1776676377706 = key

                println("Calibrated image stored as: ", key)
            end

            nothing
                


# ╔═╡ ac776c9d-77ec-4f8b-8781-47fd89884d6b

            if !isnothing(calibrated_key1776676377706)
                JIVECore.Files.showInfo(image_data[calibrated_key1776676377706])
            end
                


# ╔═╡ c0309b71-f6b4-4f51-bc92-90490e5fb35e
md"""
# 📏 Measure Image

This section allows you to **extract quantitative measurements from images and store them in a global results table**.

Each click adds a new measurement to a persistent dataset.

---

## 🧪 Steps to use it:

1. **Select the image**  
   Choose the image you want to analyze:  
   $(@bind measure_im Select([nothing, image_keys...]))

2. **Add measurement**  
   Click the button to compute and store a new measurement:
   $(@bind add_measure PlutoUI.CounterButton("Add measurement"))

---

## 📊 How it works internally

- Each click on **“Add measurement”** triggers a measurement on the currently selected image.
- Results are appended to a global table: `results_table`.
- A tracking variable (`last_add`) ensures that each button click is processed only once.

---

## ⚠️ Important behavior (VERY IMPORTANT)

### 🔹 Avoid re-executing the global state cell

The following cell initializes persistent variables:

- `results_table`
- `last_add`

👉 You should **NOT re-run this cell unless you explicitly want to reset the measurement system**.

If you re-execute it:
- The table will be recreated
- The click counter (`last_add`) will reset to zero
- Previously accumulated state may be lost or desynchronized

---

### 🔹 Behavior after re-running the button cell

If you re-execute only the button / measurement logic cell:

- `last_add` resets
- The system will think no clicks have been processed yet
- You will need to **click “Add measurement” again repeatedly**
  until you reach the same number of accumulated clicks as before

👉 In other words:
- The system does not remember past clicks after reset
- You must manually re-trigger the button to "catch up" the state

---

## 🧠 Internal logic summary

1. Select image
2. Detect new button click (`CounterButton`)
3. Compare against `last_add`
4. Compute statistics
5. Append to `results_table`
6. Update `last_add`

---

## 💡 Recommendation

- Do not re-run the initialization cell unless you want a fresh start
- Avoid re-executing only part of the pipeline unless you understand the state reset implications
- Keep the session stable for continuous measurement accumulation
"""

# ╔═╡ 1b17d9e9-8ac5-4569-af3d-63461abb2e01
md"""
##### Measure Image

Select image:
$(@bind measure_im1776679726511 Select([nothing, image_keys...]))
    
Add measurement:
$(@bind add_measure1776679726511 PlutoUI.CounterButton("Add measurement"))
    
"""


# ╔═╡ 9a06c789-75a8-47e6-8568-446f8a99858b

        last_add1776679726511 = Ref(0)
        global results_table1776679726511 = JIVECore.Analyze.DataFrame()
        nothing
        


# ╔═╡ 61425d9f-a3fa-48e8-aa1b-be56cc29b416

        let
        if !isnothing(measure_im1776679726511)
        
            img = image_data[measure_im1776679726511]
        
            # 🔥 Solo ejecuta si hubo nuevo click
            if add_measure1776679726511 > last_add1776679726511[]
        
                new_row = JIVECore.Analyze.stats_table(img)
        
                append!(results_table1776679726511, new_row)
                
                last_add1776679726511[] = add_measure1776679726511   # 👈 marca como procesado
        
            end
        
        end
        results_table1776679726511
        end
        
        


# ╔═╡ d54c23e2-cc07-44a9-a12f-c3b24cf5a4d3
md"""
##### Measure with Threshold

Select image:
$(@bind measure_thr_im1776680700012 Select([nothing, image_keys...]))

Threshold method:
$(@bind measure_thr_method1776680700012 Select(["auto","otsu"]))

Add measurement:
$(@bind add_measure1776680700012 PlutoUI.CounterButton("Add measurement"))

        
"""


# ╔═╡ 4def64e0-9b66-4138-a226-d68eced8247e

        last_add_thr1776680700012 = Ref(0)
        global results_table_thr1776680700012 = JIVECore.Analyze.DataFrame()
        nothing
        


# ╔═╡ ac5d3783-8a77-4b54-9501-3e7e38ce236b


    let
    if !isnothing(measure_thr_im1776680700012)

        img = image_data[measure_thr_im1776680700012]

                if add_measure1776680700012 > last_add_thr1776680700012[]
                new_row = JIVECore.Analyze.stats_table(
                    img;
                    threshold=measure_thr_method1776680700012
                    )
                    append!(results_table_thr1776680700012, new_row)
                    last_add_thr1776680700012[] = add_measure1776680700012
                end

    end

    results_table_thr1776680700012

    end



# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
Unitful = "~1.27.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "17429589116d695bb88fd87d339679b35d67f75e"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c25751629f5baaa27fef307f96536db62e1d754e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.27.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    LatexifyExt = ["Latexify", "LaTeXStrings"]
    NaNMathExt = "NaNMath"
    PrintfExt = "Printf"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"
    LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
    Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
    NaNMath = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
    Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╟─d0751315-644f-436d-a92a-2d37ac91cab6
# ╟─7a1c2628-8690-41d0-97a7-998695c1bf7d
# ╟─e978ebb6-277c-4aa0-8e3c-8f465e2dc7ae
# ╟─ba2a1bc3-de20-4ac3-8daf-3a2ce2eeee3a
# ╟─a435f9d2-0a3a-4bfc-b259-c75bb12aa502
# ╟─a6a5356e-a722-44ab-b9be-35d0bafadf95
# ╟─379e145d-cfb8-4d54-af92-09bf99803562
# ╟─9b26a69a-a065-4643-9938-aa5118b87e94
# ╟─8ce81514-baeb-4184-a203-550a55c0a9b8
# ╟─d8dabb38-fcdb-4bac-b6bc-940be20eb042
# ╟─559e2275-72de-49fb-9549-d335d2d5a9dd
# ╟─5609c55a-d19e-4f45-a7f9-150eb20ba614
# ╟─783a9bc6-91df-4972-8582-d9f7c1b81438
# ╟─4be3a19f-05b3-47bd-938f-c2ed6f737d5d
# ╟─a70d184b-336f-4865-80f6-9da18597b335
# ╟─f01f6e8d-00a4-477f-8a8c-199c21d62ebe
# ╟─30e02c1d-2769-49a2-8522-923e5e513ee8
# ╟─06fea810-202a-45f3-a61b-b29a2070b419
# ╟─f31bbd2e-1617-46e7-96f7-1a3c783d6063
# ╟─0c531528-f569-4c76-8728-a57ea2df3ea5
# ╟─2733c0f2-3c3b-46fe-85b9-16a01ce1cd4c
# ╟─eea2e62f-7088-48d3-a5c4-7baadd572d8e
# ╟─216dd0ba-3a38-434a-afc8-99b16cd9a266
# ╟─fbae27f2-cfe9-4333-905b-d708d1da8509
# ╟─ac776c9d-77ec-4f8b-8781-47fd89884d6b
# ╟─c0309b71-f6b4-4f51-bc92-90490e5fb35e
# ╟─1b17d9e9-8ac5-4569-af3d-63461abb2e01
# ╟─9a06c789-75a8-47e6-8568-446f8a99858b
# ╟─61425d9f-a3fa-48e8-aa1b-be56cc29b416
# ╟─d54c23e2-cc07-44a9-a12f-c3b24cf5a4d3
# ╟─4def64e0-9b66-4138-a226-d68eced8247e
# ╟─ac5d3783-8a77-4b54-9501-3e7e38ce236b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
