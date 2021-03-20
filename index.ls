App =
	oninit: !->
		@data = null
		@loaded = no

	oncreate: !->
		@data = await (await fetch \https://cdn.jsdelivr.net/gh/tiencoffee/data/guessColorImage/0.json)json!
		@loaded = yes
		m.redraw!

	view: ->
		if @loaded
			m \.column,
				m \.col,
					m \img
		else
			m \.row.full.center.middle,
				'Loading...'

m.mount appEl, App
