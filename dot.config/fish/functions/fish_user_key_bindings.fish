function fish_user_key_bindings
  # ignore EOF
  # erase delete-or-exit and bind delete-char
  bind \cd delete-char

  # z
  bind \cxb user_z_select_and_change_directory
  bind \cx\cb user_z_select_and_change_directory

  # decors/fish-ghq
  bind \cxg __ghq_repository_search
  bind \cx\cg __ghq_repository_search

  # ryotako/fish-global-abbreviation
  # upgrade to Fisher 4.x
  # https://github.com/ryotako/fish-global-abbreviation/pull/7
  # https://github.com/jorgebucaran/fisher/issues/651
  bind ' ' '__gabbr_expand; commandline -i " "'
end
