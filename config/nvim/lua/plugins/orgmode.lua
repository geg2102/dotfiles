return {
    'nvim-orgmode/orgmode',
    -- event = 'VeryLazy',
    -- ft = { 'org' },
    config = function()
        -- Setup orgmode
        require('orgmode').setup({
            org_agenda_files = '~/orgfiles/**/*',
            org_default_notes_file = '~/orgfiles/refile.org',
            org_tags_columns = -80,
            -- org_hide_leading_stars = true,
            org_indent_mode = 'noindent',
            org_adapt_indentation = true,
            org_todo_keywords = {
                'TODO(t)',
                'PROGRESS(p)',
                'WAITING(w@/!)',
                '|',
                'DONE(d!)',
                'CANCELLED(c)'
            },
            org_capture_templates = {
                t = {
                    description = 'Task',
                    template = '* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:',
                    target = '~/orgfiles/todo.org'
                },
                m = {
                    description = 'Meeting',
                    template =
                    '* MEETING with %^{Attendees} :meeting:\n  Captured: %U\n  * Notes\n    %?\n  * Action Items\n    ** TODO ',
                    target = '~/orgfiles/meeting.org'
                },
                l = {
                    description = 'Link',
                    template = '* [[%^{URL}][%^{Title}]]\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %?',
                    target = '~/orgfiles/links.org'
                },
                i = {
                    description = 'Idea/Inbox',
                    template = '* %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:',
                    target = '~/orgfiles/inbox.org'
                },
            },
        })
    end,
}
