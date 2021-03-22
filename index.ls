App =
	oninit: !->
		@colors = []
		@color = void
		@selColor = void
		@title = ""
		@img = null
		@score = 0
		@w = 0
		@audio =
			tap: new Audio \https://freesound.org/data/previews/262/262958_4932087-lq.mp3
			exact: new Audio \https://freesound.org/data/previews/174/174027_3242494-lq.mp3
			lose: new Audio \https://freesound.org/data/previews/370/370209_1954916-lq.mp3
		@nextImg!

	class: (...classes) ->
		res = []
		for cls in classes
			if Array.isArray cls
				res.push @class ...cls
			else if cls instanceof Object
				for k, v of cls
					res.push k if v
			else if cls?
				res.push cls
		res * " "

	style: (...styles) ->
		res = {}
		for style in styles
			if Array.isArray style
				style = @style ...style
			if style instanceof Object
				for k, val of style
					res[k] = val
					res[k] += \px if not cssUnitless[k] and +val
		res

	nextImg: ->
		id = _.random 210000 367250
		@img = new Image
		try
			@img.src = await (await fetch "https://guess-color-image.vercel.app/api/svg?id=#id")text!
			@img.onload = !~>
				el = document.createElement \canvas
				el.width = 1
				el.height = 1
				ctx = el.getContext \2d
				ctx.imageSmoothingEnabled = no
				ctx.drawImage @img, 0 0 1 1
				[r, g, b] = ctx.getImageData 0 0 1 1 .data
				if r and g and b
					@color = "rgb(#r,#g,#b)"
					colors = [@color]
					while colors.length < 4
						r = _.random 255
						g = _.random 255
						b = _.random 255
						color = "rgb(#r,#g,#b)"
						unless colors.includes color
							colors.push color
					@w = 180
					@colors = _.shuffle colors
					@selColor = void
					@title = 'Đâu là hình ảnh trên khi độ phân giải còn 1px? 🧐'
					m.redraw.sync!
					canvas.width = @w
					canvas.height = @w
					canvas.style.imageRendering = ""
					canvas.style.transform = ""
					canvas.style.background = ""
					mark.style.display = \none
					ctx = canvas.getContext \2d
					ctx.imageSmoothingEnabled = yes
					ctx.drawImage @img, 0 0 @w, @w
				else
					@nextImg!
			@img.onerror = !~>
				@nextImg!
		catch
			@nextImg!

	onclickColor: (color, event) !->
		{x, y, width, height} = event.target.getBoundingClientRect!
		mark.style.display = \block
		@audio.tap.play!
		anime do
			targets: mark
			left: [x + \px, x - 12 + \px]
			top: [y + \px, y - 12 + \px]
			width: [width + \px, width + 24 + \px]
			height: [height + \px, height + 24 + \px]
			borderRadius: [\20px \20px]
			opacity: [1 0]
			duration: 500
			easing: \easeOutBack
			complete: !~>
				mark.style.display = \none
		unless @selColor
			@selColor = color
			canvas.style.imageRendering = \pixelated
			anime do
				targets: @
				w: 1
				duration: 1000
				easing: \linear
				update: !~>
					canvas.width = @w
					canvas.height = @w
					canvas.style.transform = "scale(#{180 / @w})"
					ctx = canvas.getContext \2d
					ctx.imageSmoothingEnabled = no
					ctx.drawImage @img, 0 0 @w, @w
				complete: !~>
					canvas.style.background = @color
					if color is @color
						@score++
						titles =
							'Tuyệt! 🎉'
							'Đúng luôn haha! 😆'
							'Giỏi vãi! 😱'
							'Đỉnh thật! 😮'
							'Siêu! 😋'
							'Giỏi thế ai chơi! 🥺'
						@title = _.sample titles
						@audio.exact.play!
					else
						@score = 0
						titles =
							'Sai rồi! 😥'
							'Thử lại nhé! 🙁'
						@title = _.sample titles
						@audio.lose.play!
					@nextImg!
					m.redraw!

	view: ->
		m \.p-4.h-100,
			style:
				maxWidth: \600px
				margin: \auto
				backgroundImage: 'linear-gradient(145deg,#607d8bcc,#fff)'
			if @color
				m \.column.h-100.center,
					m \.row.w-100,
						style:
							height: \10%
						m \.col,
							"Điểm: #@score"
					m \h3.text-center,
						style:
							height: \20%
						@title
					m \.row.center.middle,
						style:
							height: \40%
						m \canvas#canvas,
							style:
								borderRadius: \.1px
					m \.w-100.row.gap-x-4.between.middle,
						style:
							height: \30%
						@colors.map (color) ~>
							m \.col.ratio-1x1.color,
								style:
									maxWidth: \160px
									borderRadius: \16px
									background: color
								onclick: (event) !~>
									@onclickColor color, event
			m \#mark

m.mount appEl, App
