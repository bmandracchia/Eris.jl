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

# ╔═╡ 7afcb171-70a9-45c7-90ba-8890c4520aad
pwd()

# ╔═╡ 9a639e0f-18a4-4bbc-ad51-4cd1774ee3da
md"""
# 📂 Cargar una Imagen

Esta sección te permite **abrir y visualizar imágenes** desde tu disco.

**Pasos para usarlo:**

1. **Selecciona un archivo**  
   Usa el selector de archivos para elegir la imagen que quieres cargar:
   $(@bind tmp PlutoUI.FilePicker())

2. **Cargar la imagen**  
   La imagen seleccionada se cargará en la variable interna `image_data`. Esto te permitirá trabajar con ella en los siguientes pasos.

3. **Mostrar imagen**  
   Marca la casilla para visualizar la imagen cargada:
   $(@bind show_image PlutoUI.CheckBox()) Show image

4. **Mostrar información de la imagen**  
   Marca la casilla para ver detalles de la imagen como dimensiones y tipo de datos:
   $(@bind show_info PlutoUI.CheckBox()) Show image info

> 💡 Consejo: Primero carga la imagen antes de intentar mostrarla o analizarla.
"""

# ╔═╡ bddf073d-0a54-4fa6-bca3-070911e1729c
md"""
##### Load Image
$(@bind tmp1773828748988 PlutoUI.FilePicker())
"""


# ╔═╡ 84da68e3-f1ba-40d4-b45d-3df7ac314571

            loaded_index1773828748988 = isnothing(tmp1773828748988) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1773828748988)
                nothing
            


# ╔═╡ 2a891ee9-f98d-4e99-9625-a7c6fa69479c
md"""
##### $(@bind show_image1773828748988 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ 77a5e47c-2dcb-4424-b026-6ae6ab8c77be

            if show_image1773828748988 && !isnothing(loaded_index1773828748988)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1773828748988])
                )
    
            end
            


# ╔═╡ 3c611921-0d8c-48d5-a62b-7790a812cdc8
md"""
##### $(@bind show_info1773828748988 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ 8f0464ce-ace0-486f-8abd-c82574ca1ad8

            if show_info1773828748988 && !isnothing(loaded_index1773828748988)
                JIVECore.Files.showInfo(image_data[loaded_index1773828748988])
            end
            


# ╔═╡ 53e4bcdf-2e4b-45f4-9fda-b922922980da
md"""
# 📈 Perfil de Intensidad en Línea

Esta sección permite **analizar la intensidad de los píxeles a lo largo de una línea** en la imagen seleccionada.

**Pasos para usarlo:**

1. **Selecciona la imagen**  
   Elige de la lista la imagen que quieres analizar:
   $(@bind sel_im Select([nothing, image_keys...]))

2. **Define los puntos de la línea**  
   - Punto inicial `(X1, Y1)`:
     - X1: $(@bind x1 NumberField(1:10000, default=100))
     - Y1: $(@bind y1 NumberField(1:10000, default=100))
   - Punto final `(X2, Y2)`:
     - X2: $(@bind x2 NumberField(1:10000, default=200))
     - Y2: $(@bind y2 NumberField(1:10000, default=200))

3. **Generar gráfico de intensidad**  
   Se mostrará un gráfico con la intensidad de los píxeles a lo largo de la línea definida.

4. **Mostrar línea en la imagen**  
   Se dibuja la línea seleccionada sobre la imagen para visualizar exactamente qué se está analizando.
"""

# ╔═╡ c8e08e32-cb09-4be5-9f48-e9d199f4ecfc
md"""
##### Line Intensity Profile

1. Select image: $(@bind sel_im1773828886269 Select([nothing, image_keys...]))
2. Start X: $(@bind x11773828886269 NumberField(1:10000, default=100))
3. Start Y: $(@bind y11773828886269 NumberField(1:10000, default=100))
4. End X: $(@bind x21773828886269 NumberField(1:10000, default=200))
5. End Y: $(@bind y21773828886269 NumberField(1:10000, default=200))
            
"""


# ╔═╡ 7a8947c0-0dc4-44e7-b1f2-bdaed1399f9d

if isnothing(sel_im1773828886269)
    print("Select an image")
else
    JIVECore.Visualize.plotLine(image_data[sel_im1773828886269],(x11773828886269, y11773828886269),(x21773828886269, y21773828886269),legend=true)
end


# ╔═╡ dc820aaf-3b73-4618-aa83-eef100c2eb6a

if !isnothing(sel_im1773828886269)
    img = image_data[sel_im1773828886269]
    img_line = copy(img)
    
    JIVECore.Visualize.gif(JIVECore.Draw.draw_line(img_line,(x11773828886269, y11773828886269),(x21773828886269, y21773828886269),5,value=1))
    
end


# ╔═╡ c44ce510-ce6d-41a4-9083-53de6dfe6121


# ╔═╡ Cell order:
# ╠═7afcb171-70a9-45c7-90ba-8890c4520aad
# ╟─9a639e0f-18a4-4bbc-ad51-4cd1774ee3da
# ╟─bddf073d-0a54-4fa6-bca3-070911e1729c
# ╟─84da68e3-f1ba-40d4-b45d-3df7ac314571
# ╟─2a891ee9-f98d-4e99-9625-a7c6fa69479c
# ╟─77a5e47c-2dcb-4424-b026-6ae6ab8c77be
# ╟─3c611921-0d8c-48d5-a62b-7790a812cdc8
# ╟─8f0464ce-ace0-486f-8abd-c82574ca1ad8
# ╟─53e4bcdf-2e4b-45f4-9fda-b922922980da
# ╟─c8e08e32-cb09-4be5-9f48-e9d199f4ecfc
# ╟─7a8947c0-0dc4-44e7-b1f2-bdaed1399f9d
# ╟─dc820aaf-3b73-4618-aa83-eef100c2eb6a
# ╠═c44ce510-ce6d-41a4-9083-53de6dfe6121
