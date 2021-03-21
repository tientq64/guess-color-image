App =
	oninit: !->
		@img = null
		@color = void
		@nextImg!

	nextImg: ->
		id = _.random 210000 367250
		@img = new Image
		@img.src = "https://guess-color-image.vercel.app/api/svg?id=#id"
		@img.crossOrigin = yes
		@img.onload = !~>
			canvas = document.createElement \canvas
			canvas.width = 1
			canvas.height = 1
			ctx = canvas.getContext \2d
			ctx.imageSmoothingEnabled = no
			ctx.drawImage @img, 0 0 1 1
			[r, g, b] = ctx.getImageData 0 0 1 1 .data
			@color = "rgb(#r,#g,#b)"
			m.redraw!
		@img.onerror = !~>
			@nextImg!

	view: ->
		if @color
			m \.column,
				m \.col,
					m \img,
						src: @img.src

m.mount appEl, App
