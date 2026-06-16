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

# ╔═╡ fb2aa8d1-c88e-4647-9c10-eee3649aa4e7
md"""
##### Load Image
$(@bind tmp1776425600966 PlutoUI.FilePicker())
"""


# ╔═╡ f93d3191-23f5-4aaa-9bf7-5b11b55eb879

            loaded_index1776425600966 = isnothing(tmp1776425600966) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1776425600966)
                nothing
            


# ╔═╡ c4492f55-051a-4506-8e38-b92593ad2355
md"""
##### $(@bind show_image1776425600966 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ dad1eb0e-6c08-46bc-8d79-db007c059e35

            if show_image1776425600966 && !isnothing(loaded_index1776425600966)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1776425600966])
                )
    
            end
            


# ╔═╡ 7cb9f5f8-5efc-4ded-b023-2fac93661184
md"""
##### $(@bind show_info1776425600966 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ 0edbec8f-2d23-434b-852b-adc1b44aff0f

            if show_info1776425600966 && !isnothing(loaded_index1776425600966)
                JIVECore.Files.showInfo(image_data[loaded_index1776425600966])
            end
            


# ╔═╡ c8700efe-72a0-41fa-8aa7-5eaf815488e5
md"""
# 🎛️ Color Space & Bit Depth Conversion

This section allows you to **convert an image between color spaces (grayscale/RGB) and adjust its bit depth**.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to convert:  
   $(@bind sel_im_bit Select([nothing, image_keys...]))

2. **Select color type**  
   Choose the output color representation:
   $(@bind colortype Select(["gray", "rgb"]))

3. **Select bit depth**  
   Choose the numerical precision of the image:
   $(@bind bitrate Select([8, 16, 32, 64]))

4. **Convert image**  
   The image is converted using the selected settings and stored in `image_data`.

   The output is saved with a name like:
   `original_name_gray_8bit` (depending on your selection)

5. **Show image info (optional)**  
   You can display metadata of the converted image:
   $(@bind show_info PlutoUI.CheckBox(default=false))

   This includes information such as type, dimensions, and internal format.

> 💡 Tip: Use lower bit depth (8-bit) for visualization and higher bit depth (16–32 bit) for scientific analysis to preserve precision.
"""

# ╔═╡ 0336e61c-392e-4528-85eb-a98965d2054e
md"""
##### Convert Image Bit Depth

1. Select image  
$(@bind sel_im_bit1776425641871 Select([nothing, image_keys...]))
        
2. Color type  
$(@bind colortype1776425641871 Select(["gray", "rgb"]))
        
3. Bit depth  
$(@bind bitrate1776425641871 Select([8, 16, 32, 64]))
                
"""


# ╔═╡ 62d8ac47-c056-4c42-858a-4e1b76886490

        converted_key1776425641871 = nothing
        
        if !isnothing(sel_im_bit1776425641871)
        
            # Nombre automático usando keyCheck
            base_name = string(sel_im_bit1776425641871, "_", colortype1776425641871, "_", bitrate1776425641871, "bit")
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            # Solo guardar si no existe
            if !(key in image_keys)
        
                img_original = copy(image_data[sel_im_bit1776425641871])
                img_converted = JIVECore.Data.im2bit(
                    img_original,
                    colortype1776425641871,
                    bitrate1776425641871
                )
        
                image_data[key] = img_converted
                push!(image_keys, key)
        
                println("Image stored as \"$(key)\" ")
            end
        
            converted_key1776425641871 = key
        end
        
        nothing
            


# ╔═╡ a2842f58-aea8-4540-aa93-77cde352d193
md"""
##### $(@bind show_info1776425641871 PlutoUI.CheckBox(default=false)) Show info of converted image

"""


# ╔═╡ 030113f3-e27c-4e2e-9407-438b5651d115

        if show_info1776425641871 && !isnothing(converted_key1776425641871)
            JIVECore.Files.showInfo(image_data[converted_key1776425641871])
        end
        


# ╔═╡ c760deb4-1a19-4565-bcd1-9d8d586f0805
md"""
# 🌈 Gray → LUT Mapping

This section allows you to **convert a grayscale image into a false-color image using a Look-Up Table (LUT) colormap**, and optionally add a colorbar.

**Steps to use it:**

1. **Select grayscale image**  
   Choose the image you want to convert:  
   $(@bind sel_im_lut Select([nothing, image_keys...]))

2. **Choose color scheme**  
   Select the colormap used for the conversion:
   $(@bind scheme_lut Select(["davos","viridis","magma","plasma","inferno","cividis","nuuk"]))

3. **Set colorbar position (optional)**  
   Choose where the colorbar will be displayed on the image:
   $(@bind lut_corner Select([:topleft,:topright,:bottomleft,:bottomright]))

4. **Set colorbar font size**  
   Adjust the size of the colorbar labels:
   $(@bind lut_fontsize Slider(0.01:0.001:0.1, default=0.03))

5. **Convert image**  
   The grayscale image is mapped to a colored representation using the selected LUT.  
   The result is stored in `image_data` with a name like:
   `original_name_viridis_lut`

6. **Display colorbar (automatic)**  
   The converted image is shown with an overlaid colorbar indicating intensity values.

> 💡 Tip: Use perceptually uniform colormaps like `viridis`, `magma`, or `cividis` for scientific visualization to avoid misleading intensity perception.
"""

# ╔═╡ b39fa83b-6828-4ebf-a3a2-fcbd69424d9a
md"""
##### Gray to LUT with colorbar

1. Select grayscale image  
$(@bind sel_im_lut1776425697759 Select([nothing, image_keys...]))
        
2. Color scheme  
$(@bind scheme_lut1776425697759 Select(["davos","viridis","magma","plasma","inferno","cividis","nuuk"]))
        
3. Colorbar position  $(@bind lut_corner1776425697759 Select([:topleft,:topright,:bottomleft,:bottomright]))
        
4. Colorbar fontsize  
$(@bind lut_fontsize1776425697759 Slider(0.01:0.001:0.1, default=0.03))
            
"""


# ╔═╡ 434ebfec-3af8-4b4a-992b-cb7187a7f4cb

                converted_key_lut1776425697759 = nothing
                if !isnothing(sel_im_lut1776425697759)
                
                let
                
                    local_base = string(sel_im_lut1776425697759, "_", scheme_lut1776425697759, "_lut")
                
                    key = JIVECore.Data.keyCheck(image_data, local_base)
                
                    if !(key in image_keys)
                
                        img_orig_local = copy(image_data[sel_im_lut1776425697759])
                
                        img_conv_local = JIVECore.Data.gray2lut(
                            img_orig_local,
                            Symbol(scheme_lut1776425697759)
                        )
                
                        image_data[key] = img_conv_local
                        push!(image_keys, key)
                
                        println("Image stored as \"$(key)\" ")
                
                    end
                
                    global converted_key_lut1776425697759
                    converted_key_lut1776425697759 = key
                
                end
                
                end
                
                nothing
                


# ╔═╡ 1f0e53af-e13a-4c9e-9087-d25c1bdaf9a9

                if !isnothing(converted_key_lut1776425697759)

                img_lut = copy(image_data[converted_key_lut1776425697759])

                    JIVECore.Draw.colorbar!(
                        img_lut,
                        corner=lut_corner1776425697759,
                        fontsize=lut_fontsize1776425697759,
                        scheme=Symbol(scheme_lut1776425697759)
                    )
        
                end
                
                


# ╔═╡ 1f9a1b05-0a51-4fc2-a353-8e31486120f8
md"---"

# ╔═╡ 5cb43d70-2dbc-4102-b478-3dc4644acc44
md"""
##### Load Image
$(@bind tmp1776425950882 PlutoUI.FilePicker())
"""


# ╔═╡ 0326ea7c-9c4d-4004-b1a6-9dfe5fd6ae8f

            loaded_index1776425950882 = isnothing(tmp1776425950882) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1776425950882)
                nothing
            


# ╔═╡ e6868ad8-3e4e-4c3c-8265-fbd87a63e28f
md"""
##### $(@bind show_image1776425950882 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ 61ebbb18-bf8b-4562-9b51-8e323b9b0c87

            if show_image1776425950882 && !isnothing(loaded_index1776425950882)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1776425950882])
                )
    
            end
            


# ╔═╡ 36e57ad4-dce0-4b53-972a-4184ba23f307
md"""
##### $(@bind show_info1776425950882 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ 5b5b3c60-76af-4961-aefe-a3301ce5f2ac

            if show_info1776425950882 && !isnothing(loaded_index1776425950882)
                JIVECore.Files.showInfo(image_data[loaded_index1776425950882])
            end
            


# ╔═╡ 978612c7-510d-4e60-b25e-f3dd6ebcefd7
md"""
##### RGB Channel Composition

Select image:
$(@bind rgb_im1776426350502 Select([nothing, image_keys...]))

Apply auto contrast:
$(@bind rgb_contrast1776426350503 PlutoUI.CheckBox(default=true))
            
"""


# ╔═╡ 946d7865-6a4c-43c9-99e6-26d0e8bbfe76

            if isnothing(rgb_im1776426350502)
                nC = 0
            else
                img_col = image_data[rgb_im1776426350502]

                if img_col isa JIVECore.Data.AxisArray
                    names = JIVECore.Data.axisnames(img_col)
                    c_idx = findfirst(x -> lowercase(string(x)) == "c", names)
                    nC = !isnothing(c_idx) ? size(parent(img_col), c_idx) : 3
                else
                    nC = ndims(img_col) == 3 ? size(img_col, 3) : 1
                end
            end
            nothing
            


# ╔═╡ 9be2173d-4620-4e0d-8fb5-67261ee56d7a

blocks = Any[]

push!(blocks, md"""
Channel 1:
$(@bind rgb_r1776426350503 Select([:r,:g,:b,:m,:y,:c,:gray]))
""")

if nC ≥ 2
    push!(blocks, md"Channel 2: $(@bind rgb_g1776426350503 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 3
    push!(blocks, md"Channel 3: $(@bind rgb_b1776426350503 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 4
    push!(blocks, md"Channel 4: $(@bind rgb_c41776426350503 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 5
    push!(blocks, md"Channel 5: $(@bind rgb_c51776426350503  Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

blocks
            


# ╔═╡ 5c8f4185-0c12-4a6c-b224-2b06d4d6eccb

        channels = Symbol[]
        
        push!(channels, Symbol(rgb_r1776426350503))
        
        if nC ≥ 2
            push!(channels, Symbol(rgb_g1776426350503))
        end
        
        if nC ≥ 3
            push!(channels, Symbol(rgb_b1776426350503))
        end
        
        if nC ≥ 4
            push!(channels, Symbol(rgb_c41776426350503))
        end
        
        if nC ≥ 5
            push!(channels, Symbol(rgb_c51776426350503))
        end
        
        nothing
        


# ╔═╡ 6b672e33-0d57-403c-b561-443df43e610f


            rgb_key1776426350502 = nothing

            let

            if !isnothing(rgb_im1776426350502)

                img = copy(image_data[rgb_im1776426350502])

                rgb_img = JIVECore.Data.im2rgb(
                    img;
                    channels=channels
                )

                if rgb_contrast1776426350503
                    rgb_img = JIVECore.Process.autoContrast(rgb_img)
                end

                base_name = string(rgb_im1776426350502, "_rgb")

                key = JIVECore.Data.keyCheck(image_data, base_name)

                image_data[key] = rgb_img

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global rgb_key1776426350502
                rgb_key1776426350502 = key

            end

            end

            nothing
            


# ╔═╡ 1df1ece1-54ab-4ce8-a478-574ebd03ce98
md"""
##### $(@bind rgb_show1776426350503 PlutoUI.CheckBox(default=false)) Show RGB image

"""


# ╔═╡ 18f6a0e3-2bf0-47cb-b37b-6b839f2790af


if rgb_show1776426350503 && !isnothing(rgb_key1776426350502)
    JIVECore.Visualize.gif(image_data[rgb_key1776426350502])
end



# ╔═╡ 1680acc2-8613-4b7b-aaf8-68df994d4c32


# ╔═╡ d3bd053c-56cf-4264-8889-2786ef18bb0e
md"""
##### Mosaic Image Viewer

Images to display:
$(@bind mosaic_imgs1776426441246 MultiSelect(image_keys))
        
Times to display (per image, 0-indexed):
$(@bind mosaic_times1776426441246 MultiSelect(0:49))
        
Rows:
$(@bind mosaic_nrow1776426441246 NumberField(1:10, default=1))
        
Columns:
$(@bind mosaic_ncol1776426441246 NumberField(1:10, default=1))
                    
"""


# ╔═╡ 6b7b33a4-b5c8-4683-8e34-fafb7241b4a1

        let
        
        if !isnothing(mosaic_imgs1776426441246) && length(mosaic_imgs1776426441246) > 0
        
            # Extraer imágenes seleccionadas
            imgs = map(k -> image_data[k], mosaic_imgs1776426441246)
        
            # Si hay selección de tiempos, tomar solo esos frames
            imgs = map(img -> begin
                if !isnothing(mosaic_times1776426441246) && length(mosaic_times1776426441246) > 0
                    # img[:, :, sel_times .+ 1]  # Julia es 1-indexed
                    img[:, :, mosaic_times1776426441246 .+ 1]
                else
                    img
                end
            end, imgs)
        
            println("Displaying mosaic with ", length(imgs), " images, ", length(mosaic_times1776426441246), " frames per image")
        
            JIVECore.Visualize.mosaicview(
                imgs...;
                nrow=mosaic_nrow1776426441246,
                ncol=mosaic_ncol1776426441246
            )
        
        end
        
        end
                


# ╔═╡ 1653028b-2fc7-4d2d-ba9a-c6862400e69a
md"""
# 🧩 Merge Channels

This section allows you to **combine up to three grayscale images into a single RGB composite image**, assigning each image to a specific color channel.

**Steps to use it:**

### 1. Select input images and assign channels

#### Channel 1
- Image:  
$(@bind merge_im1 Select([nothing, image_keys...]))
- Assign to color channel:  
$(@bind merge_ch1 Select([:r,:g,:b,:m,:y,:c,:gray]))

#### Channel 2
- Image:  
$(@bind merge_im2 Select([nothing, image_keys...]))
- Assign to color channel:  
$(@bind merge_ch2 Select([:r,:g,:b,:m,:y,:c,:gray]))

#### Channel 3
- Image:  
$(@bind merge_im3 Select([nothing, image_keys...]))
- Assign to color channel:  
$(@bind merge_ch3 Select([:r,:g,:b,:m,:y,:c,:gray]))

2. **Generate merged image**  
The selected images are combined into a single RGB composite using the chosen channel mapping.

The result is stored in `image_data` with a name like:
`merge_image1_image2_image3`

3. **Display merged image (optional)**  
You can visualize the result by enabling:
$(@bind show_merged PlutoUI.CheckBox(default=false))

The image is shown with automatic contrast adjustment for better visibility.

> 💡 Tip: This tool is useful for microscopy or multi-marker imaging, where each channel represents a different biological structure or signal.
"""

# ╔═╡ 9e25c547-dc5f-4d43-8a97-51845cfd6905
md"""
##### Merge Gray Channels into RGB

### Channel 1
Image:
$(@bind merge_im11776426383474 Select([nothing, image_keys...]))
Assign to:
$(@bind merge_ch11776426383474 Select([:r,:g,:b,:m,:y,:c,:gray]))
        
### Channel 2
Image:
$(@bind merge_im21776426383474 Select([nothing, image_keys...]))
Assign to:
$(@bind merge_ch21776426383474 Select([:r,:g,:b,:m,:y,:c,:gray]))
        
### Channel 3
Image:
$(@bind merge_im31776426383474 Select([nothing, image_keys...]))
Assign to:
$(@bind merge_ch31776426383474 Select([:r,:g,:b,:m,:y,:c,:gray]))
                
"""


# ╔═╡ 9e462144-d519-49be-89c5-1cfe3c11ad49

        merged_key1776426383474 = nothing
        let
        if !isnothing(merge_im11776426383474) && !isnothing(merge_im21776426383474) && !isnothing(merge_im31776426383474)
        
            img1 = copy(image_data[merge_im11776426383474])
            img2 = copy(image_data[merge_im21776426383474])
            img3 = copy(image_data[merge_im31776426383474])
        
            merged = JIVECore.Data.im2rgb(
                img1,
                img2,
                img3;
                channels=[merge_ch11776426383474, merge_ch21776426383474, merge_ch31776426383474]
            )
        
            base_name = string("merge_", merge_im11776426383474, "_", merge_im21776426383474, "_", merge_im31776426383474)
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = merged
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            println("Merged image stored as ", key)
            
            global merged_key1776426383474
            merged_key1776426383474 = key
        end
        end
        
        nothing
            


# ╔═╡ 887b119b-1aa7-4c22-848c-67bea3eb485e
md"""
##### $(@bind show_merged1776426383474 PlutoUI.CheckBox(default=false)) Show merged image

"""


# ╔═╡ d3005f5a-b1f2-47a1-9ce0-4f517e84ce46

        if show_merged1776426383474 && !isnothing(merged_key1776426383474)
            JIVECore.Visualize.gif(
                JIVECore.Process.autoContrast(image_data[merged_key1776426383474])
            )
        end
            


# ╔═╡ Cell order:
# ╟─fb2aa8d1-c88e-4647-9c10-eee3649aa4e7
# ╟─f93d3191-23f5-4aaa-9bf7-5b11b55eb879
# ╟─c4492f55-051a-4506-8e38-b92593ad2355
# ╟─dad1eb0e-6c08-46bc-8d79-db007c059e35
# ╟─7cb9f5f8-5efc-4ded-b023-2fac93661184
# ╟─0edbec8f-2d23-434b-852b-adc1b44aff0f
# ╟─c8700efe-72a0-41fa-8aa7-5eaf815488e5
# ╟─0336e61c-392e-4528-85eb-a98965d2054e
# ╟─62d8ac47-c056-4c42-858a-4e1b76886490
# ╟─a2842f58-aea8-4540-aa93-77cde352d193
# ╟─030113f3-e27c-4e2e-9407-438b5651d115
# ╟─c760deb4-1a19-4565-bcd1-9d8d586f0805
# ╟─b39fa83b-6828-4ebf-a3a2-fcbd69424d9a
# ╟─434ebfec-3af8-4b4a-992b-cb7187a7f4cb
# ╟─1f0e53af-e13a-4c9e-9087-d25c1bdaf9a9
# ╟─1f9a1b05-0a51-4fc2-a353-8e31486120f8
# ╟─5cb43d70-2dbc-4102-b478-3dc4644acc44
# ╟─0326ea7c-9c4d-4004-b1a6-9dfe5fd6ae8f
# ╟─e6868ad8-3e4e-4c3c-8265-fbd87a63e28f
# ╟─61ebbb18-bf8b-4562-9b51-8e323b9b0c87
# ╟─36e57ad4-dce0-4b53-972a-4184ba23f307
# ╟─5b5b3c60-76af-4961-aefe-a3301ce5f2ac
# ╟─978612c7-510d-4e60-b25e-f3dd6ebcefd7
# ╟─946d7865-6a4c-43c9-99e6-26d0e8bbfe76
# ╟─9be2173d-4620-4e0d-8fb5-67261ee56d7a
# ╟─5c8f4185-0c12-4a6c-b224-2b06d4d6eccb
# ╟─6b672e33-0d57-403c-b561-443df43e610f
# ╟─1df1ece1-54ab-4ce8-a478-574ebd03ce98
# ╟─18f6a0e3-2bf0-47cb-b37b-6b839f2790af
# ╠═1680acc2-8613-4b7b-aaf8-68df994d4c32
# ╟─d3bd053c-56cf-4264-8889-2786ef18bb0e
# ╟─6b7b33a4-b5c8-4683-8e34-fafb7241b4a1
# ╟─1653028b-2fc7-4d2d-ba9a-c6862400e69a
# ╟─9e25c547-dc5f-4d43-8a97-51845cfd6905
# ╟─9e462144-d519-49be-89c5-1cfe3c11ad49
# ╟─887b119b-1aa7-4c22-848c-67bea3eb485e
# ╟─d3005f5a-b1f2-47a1-9ce0-4f517e84ce46
