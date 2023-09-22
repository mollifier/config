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
end
