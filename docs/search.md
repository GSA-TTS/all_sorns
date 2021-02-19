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
ability. We combined two approaches to implementing it in SORN DASH.

By default, searches are made against all of our SORN data at once. We
use a [materialized
view](https://www.postgresql.org/docs/13/rules-materializedviews.html)
to combine all of this data into one single column that is optimized for
full text search. This view needs to be refreshed whenever the data
changes, which is once a day in our case.

If a user applies filters to narrow their search to a subset of columns
or agencies, then we use a different approach. We've created [generated
columns](https://www.postgresql.org/docs/13/ddl-generated-columns.html)
for each of our existing data columns that are optimized for full text
search. We then search against the subset of columns selected by the
user. These columns are always up to date. Custom search is not as fast
as searches using materialized views, but is still much faster than
searching these columns directly. Generated columns are a new type, just
introduced in PostgreSQL 12.

The materialized view is created and versioned by the great [Scenic
gem](https://github.com/scenic-views/scenic). The view is searched
against by the **FullSornSearch** model.

Both approaches for full text search use the incredible [**pg\_search
gem**](https://github.com/Casecommons/pg_search).

These two articles explaining these approaches were very helpful:

  - [Optimizing full-text search with Postgres materialized view in
    Rails](https://caspg.com/blog/optimizing-full-text-search-with-postgres-materialized-view-in-rails)

  - [Full Text Search in Milliseconds with Rails and
    PostgreSQL](https://pganalyze.com/blog/full-text-search-ruby-rails-postgres)
