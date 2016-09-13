$("#<%= dom_id(@law) %> .js-flag-actions").html('<%= j render("laws/flag_actions", law: @law) %>');
