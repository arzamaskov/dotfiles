journal() {
  local file="$HOME/journal/index.txt"
  local command="${1:-open}"

  case "$command" in
    open)
      nvim "$file"
      ;;

    today)
      local md
      md="$(date +%m-%d)"

      awk -v md="$md" '
        /^[0-9]{4}-[0-9]{2}-[0-9]{2} / {
          show = substr($0, 6, 5) == md
        }

        show {
          print
        }
      ' "$file"
      ;;

    *)
      echo "usage: journal [open|today]" >&2
      return 1
      ;;
  esac
}

jsync() {
  git_backup "$JOURNAL_DIR" "log from $(date '+%Y-%m-%d')"
}

j() {
  nvim "$JOURNAL_DIR/index.txt"
}

jr() {
  cat "$JOURNAL_DIR/index.txt"
}
