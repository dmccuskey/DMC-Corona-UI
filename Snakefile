# DMC-Corona-Widgets

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "DMC-Corona-Widgets"
	include: "../DMC-Corona-Widgets/snakemake/Snakefile"

module_config = {
	"name": "DMC-Corona-Widgets",
	"module": {
		"dir": "lib",
		"files": [
			"dmc_widgets.lua",
			"dmc_widgets/button_group.lua",
			"dmc_widgets/data_formatters.lua",
			"dmc_widgets/font_manager.lua",
			"dmc_widgets/lib/easingx.lua",
			"dmc_widgets/scroller_view_base.lua",
			"dmc_widgets/theme_manager.lua",
			"dmc_widgets/widget_style/base_style.lua",
			"dmc_widgets/widget_style/background_style.lua",
			"dmc_widgets/widget_style/text_style.lua",
			"dmc_widgets/widget_style/textfield_style.lua",
			"dmc_widgets/widget_background.lua",
			"dmc_widgets/widget_button.lua",
			"dmc_widgets/widget_button/view_9slice.lua",
			"dmc_widgets/widget_button/view_base.lua",
			"dmc_widgets/widget_button/view_image.lua",
			"dmc_widgets/widget_button/view_shape.lua",
			"dmc_widgets/widget_navbar.lua",
			"dmc_widgets/widget_navitem.lua",
			"dmc_widgets/widget_popover.lua",
			"dmc_widgets/widget_popover/popover_mix.lua",
			"dmc_widgets/widget_popover/popover_view.lua",
			"dmc_widgets/widget_slideview.lua",
			"dmc_widgets/widget_tableview.lua",
			"dmc_widgets/widget_text.lua",
			"dmc_widgets/widget_textfield.lua",
			"dmc_widgets/widget_theme_mix.lua",
			"dmc_widgets/widget_utils.lua",
			"dmc_widgets/widget_viewpager.lua"
		],
		"requires": [
			"dmc-corona-boot",
			"DMC-Lua-Library",
			"DMC-Corona-Library"
		]
	},
	"examples": {
		"base_dir": "examples",
		"apps": [
			{
				"exp_dir": "background-widget/background-themed",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "button-widget/button-9slice-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "button-widget/button-image-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "button-widget/button-radio-group",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "button-widget/button-shape-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "button-widget/button-text-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "navbar-widget/navbar-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "popover-widget/popover-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "slide_view-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "table_view-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "text-widget/text-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "text-widget/text-themed",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "textfield-widget/textfield-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "textfield-widget/textfield-themed",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			}
		]
	},
	"tests": {
		"dir": "spec",
		"files": [],
		"requires": []
	}
}

register( "DMC-Corona-Widgets", module_config )


