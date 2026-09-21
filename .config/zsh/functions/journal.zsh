journal() {
  local file="$JOURNAL_DIR/index.txt"
  local command="${1:-open}"

  case "$command" in
    open)
      nvim "$file"
      ;;

    today)
      journal_history "$file" "$(date '+%m-%d')"
      ;;

    [0-9][0-9]-[0-9][0-9])
      journal_history "$file" "$command"
      ;;

    tasks)
      journal_tasks "$file"
      ;;

    search)
      shift
      journal_search "$file" "$@"
      ;;

    sync)
      journal_sync
      ;;

    help | -h | --help)
      journal_help
      ;;

    *)
      echo "unknown command: $command" >&2
      echo "run 'journal help' for usage" >&2
      return 1
      ;;
  esac
}

journal_history() {
  local file="$1"
  local md="$2"

  printf '\n'

  awk -v md="$md" '
    /^[0-9]{4}-[0-9]{2}-[0-9]{2} / {
      match_day = substr($0, 6, 5) == md

      if (match_day && found) {
        print "----------------------------------------"
        print ""
      }

      if (match_day) {
        found = 1
      }

      show = match_day
    }

    show {
      print
    }
  ' "$file"
}

journal_tasks() {
  local file="$1"

  printf '\n'

  awk '
    /^[0-9]{4}-[0-9]{2}-[0-9]{2} / {
      date = $0
    }

    /^- / {
      if (date != last_date) {
        if (found) {
          print ""
        }

        print date
        print ""

        last_date = date
        found = 1
      }

      print
    }
  ' "$file"
}

journal_search() {
  local file="$1"
  shift

  if (( $# == 0 )); then
    echo "usage: journal search <query>" >&2
    return 1
  fi

  local query="$*"
  local mode="text"

  case "$query" in
    tel | addr | mail | person | link | term)
      mode="prefix"
      ;;
  esac

  printf '\n'

  awk -v query="$query" -v mode="$mode" '
    /^[0-9]{4}-[0-9]{2}-[0-9]{2} / {
      date = $0
      next
    }

    {
      if (mode == "prefix") {
        matched = index($0, query " ") == 1
      } else {
        matched = index(tolower($0), tolower(query)) > 0
      }

      if (matched) {
        if (date != last_date) {
          if (found) {
            print ""
          }

          print date
          print ""

          last_date = date
        }

        print
        found = 1
      }
    }

    END {
      if (!found) {
        print "No matches."
      }
    }
  ' "$file" |
    rg --passthru --color=always -i -F -- "$query"
}

journal_sync() {
  git -C "$JOURNAL_DIR" pull --ff-only || return 1

  git -C "$JOURNAL_DIR" add index.txt

  if ! git -C "$JOURNAL_DIR" diff --cached --quiet; then
    git -C "$JOURNAL_DIR" commit \
      -m "journal update: $(date '+%Y-%m-%d %H:%M')" || return 1
  fi

  git -C "$JOURNAL_DIR" push origin
}

journal_help() {
  cat <<'EOF'
Usage:
  journal                  Open the journal
  journal today            Show this day across all years
  journal MM-DD            Show a specific day across all years
  journal tasks            Show open tasks
  journal search QUERY     Search the journal
  journal sync             Pull, commit and push changes
  journal help             Show this help

Search:
  Known prefixes are searched at the beginning of a line:
    tel addr mail person link term

  Other queries are searched as case-insensitive literal text.

Examples:
  journal search term
  journal search tel
  journal search run
  journal search "Zone 2"
EOF
}

jr() {
  cat "$JOURNAL_DIR/index.txt"
}
