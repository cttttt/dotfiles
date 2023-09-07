_fzf_compgen_dir ()
{
    ( cd ~/src/github.com && {
        compgen -G '*/*'
      }
    )
    command find -L "$1" -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
}
