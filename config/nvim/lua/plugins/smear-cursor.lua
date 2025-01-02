return {
    {
        "sphamba/smear-cursor.nvim",
        opts = {                           -- Default  Range
            stiffness = 0.6,               -- 0.6      [0, 1]
            trailing_stiffness = 0.3,      -- 0.3      [0, 1]
            distance_stop_animating = 0.1, -- 0.1      > 0
            hide_target_hack = true,       -- true     boolean
        },
    },
    {
        "karb94/neoscroll.nvim",
        opts = {},
    }
}
