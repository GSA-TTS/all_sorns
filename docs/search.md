# Search

SORN DASH provides more granular search options for SORNs than what is
available through the Federal Register, by converting SORNs from
narrative documents into structured database records. We focused on
implementing search methods for quickly finding exact matches, because
our research showed that displaying highlighted snippets of the location
of exact terms or phrases was useful to our users.

## How search works

We use postgres' built-in [full text
search](https://www.postgresql.org/docs/current/textsearch.html)
ability via the the incredible [**pg\_search gem**](https://github.com/Casecommons/pg_search).

By default, searches are made against the `xml` column returning any SORN
that contains the search term anywhere in the document.

If a user applies filters to narrow their search to a subset of columns
or agencies, then we search just those columns. We've created [generated
columns](https://www.postgresql.org/docs/13/ddl-generated-columns.html)
for each of our existing data columns that are optimized for full text
search. We then search against the subset of columns selected by the
user. The more columns a user chooses the slower the search gets.
Generated columns are a new type, just introduced in PostgreSQL 12.

The following article was helpful as we were building:
  - [Full Text Search in Milliseconds with Rails and
    PostgreSQL](https://pganalyze.com/blog/full-text-search-ruby-rails-postgres)
