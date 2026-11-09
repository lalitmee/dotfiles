[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    syntax-theme = Omarchy
    minus-style = syntax "{{ mix background red 15% }}"
    plus-style = syntax "{{ mix background green 15% }}"
    minus-emph-style = syntax "{{ mix background red 35% }}"
    plus-emph-style = syntax "{{ mix background green 35% }}"
    line-numbers-minus-style = "{{ red }}"
    line-numbers-plus-style = "{{ green }}"
    file-style = "{{ accent }}" bold
    hunk-header-style = syntax "{{ selection }}"
