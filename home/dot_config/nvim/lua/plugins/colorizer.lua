return {
  {
    "norcalli/nvim-colorizer.lua",
    enabled = true,
    opts = {
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn and hsl_fn
      },
      json = {
        mode = "background",
      },
      cpp = {
        mode = "background",
      },
      markdown = {
        mode = "background",
      },
      svg = {
        mode = "background",
      },
      qml = {
        mode = "background",
      },
    },
  },
}
