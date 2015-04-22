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
			"dmc_ui.lua",
			"dmc_ui/core/widget.lua",
			"dmc_ui/core/style.lua",
			"dmc_ui/ui_constants.lua",
			"dmc_ui/ui_utils.lua",

			"dmc_ui/dmc_control.lua",
			"dmc_ui/dmc_control/core/presentation_control.lua",
			"dmc_ui/dmc_control/core/view_control.lua",
			"dmc_ui/dmc_control/navigation_control.lua",
			"dmc_ui/dmc_control/popover_control.lua",

			"dmc_ui/dmc_style.lua",
			"dmc_ui/dmc_style/background_style.lua",
			"dmc_ui/dmc_style/background_style/base_view_style.lua",
			"dmc_ui/dmc_style/background_style/nine_slice_style.lua",
			"dmc_ui/dmc_style/background_style/rectangle_style.lua",
			"dmc_ui/dmc_style/background_style/rounded_style.lua",
			"dmc_ui/dmc_style/background_style/style_factory.lua",
			"dmc_ui/dmc_style/button_state.lua",
			"dmc_ui/dmc_style/button_style.lua",
			"dmc_ui/dmc_style/navbar_style.lua",
			"dmc_ui/dmc_style/navitem_style.lua",
			"dmc_ui/dmc_style/scrollview_style.lua",
			"dmc_ui/dmc_style/style_manager.lua",
			"dmc_ui/dmc_style/style_mix.lua",
			"dmc_ui/dmc_style/tableview_style.lua",
			"dmc_ui/dmc_style/tableviewcell_style.lua",
			"dmc_ui/dmc_style/tableviewcell_style/tableviewcell_state.lua",
			"dmc_ui/dmc_style/text_style.lua",
			"dmc_ui/dmc_style/textfield_style.lua",

			"dmc_ui/dmc_widget.lua",
			"dmc_ui/dmc_widget/button_group.lua",
			"dmc_ui/dmc_widget/font_manager.lua",
			"dmc_ui/dmc_widget/lib/easingx.lua",
			"dmc_ui/dmc_widget/widget_background.lua",
			#"dmc_ui/dmc_widget/widget_background/image_view.lua",
			"dmc_ui/dmc_widget/widget_background/nine_slice_view.lua",
			"dmc_ui/dmc_widget/widget_background/rectangle_view.lua",
			"dmc_ui/dmc_widget/widget_background/rounded_view.lua",
			"dmc_ui/dmc_widget/widget_background/view_factory.lua",
			"dmc_ui/dmc_widget/widget_button.lua",
			"dmc_ui/dmc_widget/widget_button/button_base.lua",
			"dmc_ui/dmc_widget/widget_button/button_push.lua",
			"dmc_ui/dmc_widget/widget_button/button_radio.lua",
			"dmc_ui/dmc_widget/widget_button/button_toggle.lua",
			"dmc_ui/dmc_widget/widget_navbar.lua",
			"dmc_ui/dmc_widget/widget_navbar/delegate_navbar.lua",
			"dmc_ui/dmc_widget/widget_navitem.lua",
			"dmc_ui/dmc_widget/widget_scrollview.lua",
			"dmc_ui/dmc_widget/widget_scrollview/axis_motion.lua",
			"dmc_ui/dmc_widget/widget_scrollview/scale_motion.lua",
			"dmc_ui/dmc_widget/widget_scrollview/scroller.lua",
			"dmc_ui/dmc_widget/widget_slideview.lua",
			"dmc_ui/dmc_widget/widget_tableview.lua",
			"dmc_ui/dmc_widget/widget_tableview/delegate_tableview.lua",
			"dmc_ui/dmc_widget/widget_tableviewcell.lua",
			"dmc_ui/dmc_widget/assets/tableviewcell/accessory-checkmark.png",
			"dmc_ui/dmc_widget/assets/tableviewcell/accessory-detail-button.png",
			"dmc_ui/dmc_widget/assets/tableviewcell/accessory-disclose-indicator.png",
			"dmc_ui/dmc_widget/widget_text.lua",
			"dmc_ui/dmc_widget/widget_textfield.lua",
			"dmc_ui/dmc_widget/widget_textfield/delegate_textfield.lua",
			"dmc_ui/dmc_widget/widget_viewpager.lua",

			"dmc_ui/theme/default/textfield/01-TL.png",
			"dmc_ui/theme/default/textfield/02-TM.png",
			"dmc_ui/theme/default/textfield/03-TR.png",
			"dmc_ui/theme/default/textfield/04-ML.png",
			"dmc_ui/theme/default/textfield/05-MM.png",
			"dmc_ui/theme/default/textfield/06-MR.png",
			"dmc_ui/theme/default/textfield/07-BL.png",
			"dmc_ui/theme/default/textfield/08-BM.png",
			"dmc_ui/theme/default/textfield/09-BR.png",
			"dmc_ui/theme/default/textfield/textfield-sheet.lua",
			"dmc_ui/theme/default/textfield/textfield-sheet.png",

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
				"exp_dir": "background-widget/background-9slice",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "background-widget/background-rectangle",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "background-widget/background-rounded",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "background-widget/background-styled",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
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
				"exp_dir": "navigation-control/navigation-control-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "popover-control/popover-control-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "scrollview-widget/scrollview-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "scrollview-widget/scrollview-zoom",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "tableview-widget/tableview-modify",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "tableview-widget/tableview-scroll",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "tableview-widget/tableview-simple",
				"requires": [],
				"mod_dir_map": {
					"default_dir": "",
					"libs": {
						"dmc-corona-boot":""
					}
				}
			},
			{
				"exp_dir": "tableview-widget/tableview-tableviewcell",
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
				"exp_dir": "text-widget/text-styled",
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
				"exp_dir": "textfield-widget/textfield-styled",
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


