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

# ╔═╡ 61824962-a44f-4189-aa21-725d5cf80a3d
md"""
##### Load Image
$(@bind tmp1773833549339 PlutoUI.FilePicker())
"""


# ╔═╡ a9ae21e0-1ae1-41e8-8eab-471f363d9a30

            loaded_index1773833549339 = isnothing(tmp1773833549339) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1773833549339)
                nothing
            


# ╔═╡ 9fb09747-20a5-4748-81b5-88d3e5729b18
md"""
##### $(@bind show_image1773833549339 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ 6fd0cac0-27fe-4e3e-ae18-b60f7c32fe96

            if show_image1773833549339 && !isnothing(loaded_index1773833549339)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1773833549339])
                )
    
            end
            


# ╔═╡ ef8dcce0-ca47-4f33-a689-91a36377b7b5
md"""
##### $(@bind show_info1773833549339 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ 31adbfb4-6ee9-4b74-8a93-68801c584800

            if show_info1773833549339 && !isnothing(loaded_index1773833549339)
                JIVECore.Files.showInfo(image_data[loaded_index1773833549339])
            end
            


# ╔═╡ 8ea6e7ab-6048-4414-9d33-c4a76899fa64
md"""
# ⚙️ Calibrate Image Parameters

This section allows you to **calibrate the image axes** (horizontal, vertical, and time) using physical values and units.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to calibrate:  
   $(@bind sel_im Select([nothing, image_keys...]))

2. **Choose the axes to calibrate**  
   Check the axes you want to calibrate: Horizontal, Vertical, and/or Time.

3. **Enter calibration values**  
   - Horizontal value and unit  
   - Vertical value and unit  
   - Time value and unit (for example, seconds or milliseconds)

4. **Calibrate image**  
   The image will be calibrated automatically once selected.  
   This will create a **new calibrated image** with the `_calibrated` suffix.  

> 💡 Tip: Calibrate first before drawing scalebars or timestamps so that physical units are applied correctly.
"""

# ╔═╡ ea0e2eeb-f191-485e-ae54-397811ac872f
md"""
##### Calibrate Parameters

1. Select Image
$(@bind sel_im1773838068395 Select([nothing, image_keys...]))
            
2. Choose axes to calibrate:
Horizontal $(@bind calibrate_h1773838068395 PlutoUI.CheckBox(true))
Vertical   $(@bind calibrate_v1773838068395 PlutoUI.CheckBox())
Time      $(@bind calibrate_t1773838068395 PlutoUI.CheckBox())
            
Horizontal value: $(@bind h_val1773838068395 NumberField(0:0.001:10, default=0.001))
Horizontal unit: $(@bind h_unit1773838068395 Select(["mm", "μm"]))
            
Vertical value: $(@bind v_val1773838068395 NumberField(0:0.1:10, default=1))
Vertical unit: $(@bind v_unit1773838068395 Select(["mm", "μm"]))
            
Time value: $(@bind t_val1773838068395 NumberField(0:1:100, default=1))
Time unit: $(@bind t_unit1773838068395 Select(["s", "ms"]))
                    
"""


# ╔═╡ 204825d6-9864-41cf-a9c2-a23f88548fd1

            using Unitful

            calibrated_key1773838068395 = nothing

            if !isnothing(sel_im1773838068395)

                # Construir diccionario de spacings para todos los ejes
                spacings = Dict{Symbol,Any}()

                # Horizontal
                spacings[:h] = calibrate_h1773838068395 ? h_val1773838068395 * (h_unit1773838068395 == "mm" ? Unitful.mm : Unitful.μm) : 1

                # Vertical
                spacings[:v] = calibrate_v1773838068395 ? v_val1773838068395 * (v_unit1773838068395 == "mm" ? Unitful.mm : Unitful.μm) : 1

                # Time
                spacings[:time] = calibrate_t1773838068395 ? t_val1773838068395 * (t_unit1773838068395 == "s" ? Unitful.s : Unitful.ms) : 1

                # Calibrar imagen
                img2 = JIVECore.Data.imCalibrate(image_data[sel_im1773838068395]; spacings...)

                # Guardar imagen calibrada
                key = JIVECore.Data.keyCheck(image_data, string(sel_im1773838068395, "_calibrated"))
                image_data[key] = img2

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global calibrated_key1773838068395
                calibrated_key1773838068395 = key

                println("Calibrated image stored as: ", key)
            end

            nothing
                


# ╔═╡ bedbf786-46ba-4440-9fca-b9b1703f045d

            if !isnothing(calibrated_key1773838068395)
                JIVECore.Files.showInfo(image_data[calibrated_key1773838068395])
            end
                


# ╔═╡ 2d24252c-bc76-409a-8d3f-96437b4b0f1d
md"""
# 📏 Draw Scale Bar

This section allows you to **add scale bars** to a calibrated image.

**Steps to use it:**

1. **Select the image**  
   Choose the calibrated image to which you want to add the scale bar:  
   $(@bind sb_im Select([nothing, image_keys...]))

2. **Configure the horizontal scale bar**  
   - Horizontal bar size  
   - Corner where it is drawn (Top-Left, Top-Right, Bottom-Left, Bottom-Right)

3. **Configure the vertical scale bar**  
   - Vertical bar size  
   - Corner where it is drawn  

> 💡 Tip: Apply the scale bar only to calibrated images so that the lengths correspond to physical units.
"""

# ╔═╡ 301226ee-0f3d-472a-9dfc-32b6dc9d3eb9
md"""
##### Draw Scale Bar

Select Image:
$(@bind sb_im1775557460103 Select([nothing, image_keys...]))
    
Horizontal scalebar size:
$(@bind sb_h_size1775557460103 NumberField(0.001:0.001:100, default=50))
Corner H:
$(@bind sb_h_corner1775557460103 Select([:bottomleft, :bottomright, :topleft, :topright], default=:bottomleft))
    
Vertical scalebar size:
$(@bind sb_v_size1775557460103 NumberField(0.001:0.001:100, default=50))
Corner V:
$(@bind sb_v_corner1775557460103 Select([:bottomleft, :bottomright, :topleft, :topright], default=:bottomleft))
        
"""


# ╔═╡ 2f3e6189-b73a-4fc0-a124-870c4093e0e7

        img_out = nothing
        let
        if !isnothing(sb_im1775557460103)


            key = string(sb_im1775557460103, "_scalebar")

            img_orig = image_data[sb_im1775557460103]
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
                    sb_h_size1775557460103 * h_unit,
                    direction=:h,
                    fontsize=0.04,
                    fcolor=(1,1,1),
                    channels=[:h,:v],
                    corner=sb_h_corner1775557460103,
                    show_text=true
                )
            
                JIVECore.Draw.scalebar!(
                    img_out,
                    sb_v_size1775557460103 * v_unit,
                    direction=:v,
                    fontsize=0.04,
                    fcolor=(1,1,1),
                    channels=[:h,:v],
                    corner=sb_v_corner1775557460103,
                    show_text=true
                )
        
            
            image_data[key] = img_out

            # Añadir a image_keys si no existe
            if !(key in image_keys)
                push!(image_keys, key)
            end

            global sb_out_key1775557460103
            sb_out_key1775557460103 = key

            println("Image with scale bar saved as: ", key)
        end

        end
        


# ╔═╡ 4f8cc60d-6b81-4fac-95e1-3b755ca5f811
md"""
# ⏱ Add Timestamp

This section allows you to **add timestamps to the image**, displaying the time of each frame in the selected corner.

**Steps to use it:**

1. **Select the image.**  
   Only **one image** is allowed at a time:  
   $(@bind timestamp_img Select([nothing, image_keys...]))

2. **Optional: select frames**  
   You can choose specific frames to which the timestamp will be added (0-indexed).

3. **Configure the timestamp style**  
   - Font size: size of the text  
   - Corner: corner where the timestamp is drawn (Top-Left, Top-Right, Bottom-Left, Bottom-Right)

> 💡 Tip: Apply timestamps only after calibrating and/or adding scale bars if you want them to be visible in the same image.
"""

# ╔═╡ fbf804de-2ee6-4b07-97b2-5c63198595b8
md"""
##### Timestamp Options

Image to add timestamp:
$(@bind timestamp_img1775558009227 Select([nothing, image_keys...]))

Font size:
$(@bind timestamp_fontsize1775558009227 NumberField(0.01:0.01:0.2, default=0.06))

Corner:
$(@bind timestamp_corner1775558009227 Select(["topleft","topright","bottomleft","bottomright"], default="topright"))
            
"""


# ╔═╡ b426b343-9f34-4331-8a52-5017ad18c963

let
    if !isnothing(timestamp_img1775558009227)

        img = image_data[timestamp_img1775558009227]

        # Agregar timestamp
        JIVECore.Draw.timestamp!(img; channels=[:h,:v,:time], fontsize=timestamp_fontsize1775558009227, corner=Symbol(timestamp_corner1775558009227))

        # Sobrescribir la imagen
        image_data[timestamp_img1775558009227] = img

        println("Timestamp added to image: ", timestamp_img1775558009227)

end
end
        


# ╔═╡ d0ea3262-935b-47d5-9424-11cc053fde47
md"""
# 🖼 Mosaic Viewer

This section allows you to **visualize multiple images and frames in a mosaic**.

**Steps to use it:**

1. **Select the images**  
   Choose one or more images to display:  
   $(@bind mosaic_imgs MultiSelect(image_keys))

2. **Optional: select frames**  
   You can choose specific frames (0-indexed) that you want to display from each image.

3. **Configure the mosaic**  
   - Rows: number of rows in the mosaic  
   - Columns: number of columns in the mosaic  

> 💡 Tip: If you select multiple images and frames, each frame will be displayed as a separate image in the mosaic.
"""

# ╔═╡ 12c68d73-4052-4f09-b376-94cee5136024
md"""
##### Mosaic Image Viewer

Images to display:
$(@bind mosaic_imgs1775558106532 MultiSelect(image_keys))
        
Times to display (per image, 0-indexed):
$(@bind mosaic_times1775558106532 MultiSelect(0:49))
        
Rows:
$(@bind mosaic_nrow1775558106532 NumberField(1:10, default=1))
        
Columns:
$(@bind mosaic_ncol1775558106532 NumberField(1:10, default=1))
                    
"""


# ╔═╡ 3e78499e-b9e1-415b-96db-9ed8567ecedc

        let
        
        if !isnothing(mosaic_imgs1775558106532) && length(mosaic_imgs1775558106532) > 0
        
            # Extraer imágenes seleccionadas
            imgs = map(k -> image_data[k], mosaic_imgs1775558106532)
        
            # Si hay selección de tiempos, tomar solo esos frames
            imgs = map(img -> begin
                if !isnothing(mosaic_times1775558106532) && length(mosaic_times1775558106532) > 0
                    # img[:, :, sel_times .+ 1]  # Julia es 1-indexed
                    img[:, :, mosaic_times1775558106532 .+ 1]
                else
                    img
                end
            end, imgs)
        
            println("Displaying mosaic with ", length(imgs), " images, ", length(mosaic_times1775558106532), " frames per image")
        
            JIVECore.Visualize.mosaicview(
                imgs...;
                nrow=mosaic_nrow1775558106532,
                ncol=mosaic_ncol1775558106532
            )
        
        end
        
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
# ╟─61824962-a44f-4189-aa21-725d5cf80a3d
# ╟─a9ae21e0-1ae1-41e8-8eab-471f363d9a30
# ╟─9fb09747-20a5-4748-81b5-88d3e5729b18
# ╟─6fd0cac0-27fe-4e3e-ae18-b60f7c32fe96
# ╟─ef8dcce0-ca47-4f33-a689-91a36377b7b5
# ╟─31adbfb4-6ee9-4b74-8a93-68801c584800
# ╟─8ea6e7ab-6048-4414-9d33-c4a76899fa64
# ╟─ea0e2eeb-f191-485e-ae54-397811ac872f
# ╟─204825d6-9864-41cf-a9c2-a23f88548fd1
# ╟─bedbf786-46ba-4440-9fca-b9b1703f045d
# ╟─2d24252c-bc76-409a-8d3f-96437b4b0f1d
# ╟─301226ee-0f3d-472a-9dfc-32b6dc9d3eb9
# ╟─2f3e6189-b73a-4fc0-a124-870c4093e0e7
# ╟─4f8cc60d-6b81-4fac-95e1-3b755ca5f811
# ╟─fbf804de-2ee6-4b07-97b2-5c63198595b8
# ╟─b426b343-9f34-4331-8a52-5017ad18c963
# ╟─d0ea3262-935b-47d5-9424-11cc053fde47
# ╟─12c68d73-4052-4f09-b376-94cee5136024
# ╟─3e78499e-b9e1-415b-96db-9ed8567ecedc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
