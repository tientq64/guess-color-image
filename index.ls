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

	nextImg: ->
		id = _.random 210000 367250
		@img = new Image
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
				canvas.style.transform = ""
				canvas.style.background = ""
				ctx = canvas.getContext \2d
				ctx.imageSmoothingEnabled = no
				ctx.drawImage @img, 0 0 @w, @w
			else
				@nextImg!
		@img.onerror = !~>
			@nextImg!

	onclickColor: (color) !->
		unless @selColor
			@audio.tap.play!
			@selColor = color
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
						titles =
							'Sai rồi! 😥'
							'Thử lại nhé! 🙁'
						@title = _.sample titles
						@audio.lose.play!
						await anime do
							targets: @
							score: 0
							duration: 2000
							easing: \easeOutQuad
							update: !~>
								@score = Math.round @score
								m.redraw!
						.finished
					@nextImg!
					m.redraw!

	view: ->
		m \.p-4.h-100,
			style:
				maxWidth: \600px
				margin: \auto
			if @color
				m \.column.h-100.center,
					m \.col-1.row.w-100,
						m \.col,
							"Điểm: #@score"
					m \h3.col-2.text-center,
						@title
					m \.col-5.row.center.middle,
						m \canvas.img-pixelated,
							id: \canvas
							style:
								borderRadius: \.05px
					m \.col-4.w-100.row.gap-x-4.between.middle,
						@colors.map (color) ~>
							m \.col.ratio-1x1.color,
								style:
									maxWidth: \160px
									borderRadius: \8px
									background: color
								onclick: !~>
									@onclickColor color

m.mount appEl, App
