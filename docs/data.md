# Data

All of the data in SORN DASH comes from the Federal Register, which is
the canonical source for all System of Record Notices (SORNs). SORN DASH
retrieves all available SORNs from the Federal Register’s API in XML
format and parses their content and meta-data and stores the data in the
app’s database.

## System of Record Notices (SORNs)

System of Record Notices or SORNs are public records about the
information systems government agencies handle and maintain personally
identifiable information (PII). The [Privacy Act of 1974](https://www.justice.gov/opcl/overview-privacy-act-1974-2015-edition)
requires that all federal agencies publish notices for any system that
contains records about individuals that can be retrieved by a unique
identifier (ex. name or social security number).

The Office of Management and Budget issues guidance on the
responsibilities of agencies to review, publish, and update SORNS. In
2016, OMB reissued their guidance in OMB Circular A-108, which expanded
the guidance and included templates for agencies to use when publishing
SORNs. Agencies generally follow the same format and same section
headings, but there is a lot of variation in the content of those
sections that makes parsing SORNs more difficult.

SORNs are published with an ’action’ that describes the reason an agency
is publishing the notice. SORN actions announce new systems, modify
SORNs for existing systems, or rescind SORNs for systems no longer in
use. A-108 templates provide specific language to use for each type of
action.

The Federal Register has digital versions of SORNs going back to 1994.
Many SORNs published before 2000 are not available in XML format, but
are available in plain-text (about 962 SORNs).

SORNs are public documents and part of the public record of government
activity maintained in the Federal Register.

## Federal Register API

The Federal Register has a [<span class="underline">well
documented</span>](https://www.federalregister.gov/developers/documentation/api/v1)
API for its content. No account or API key is required to make requests.
We use the [<span class="underline">Federal Register’s Ruby
Gem</span>](https://rubygems.org/gems/federal_register) to make these
requests.

To find all SORNS available through the API, we request every record
that includes ‘Privacy Act of 1974; System of Records’ in the **title**
field. We then keep only results that have either **'privacy act'** or
**'system of record'** in the title,

The code for this request is in this file:
[<span class="underline">https://github.com/18F/all\_sorns/blob/main/app/models/federal\_register\_client.rb</span>](https://github.com/18F/all_sorns/blob/main/app/models/federal_register_client.rb)

More about the Federal Register:
[<span class="underline">https://www.govinfo.gov/help/fr</span>](https://www.govinfo.gov/help/fr)

## Parsing XML

Federal Register uses an [<span class="underline">XML
schema</span>](https://www.govinfo.gov/bulkdata/FR/resources) for all
its records. This schema is primarily for formatting and presentation
and has only limited semantic tags for the type of content in each
section. Here is an
[<span class="underline">example</span>](https://www.federalregister.gov/documents/full_text/xml/2019/10/08/2019-21885.xml).

The tags for specific document sections are:

**Supplementary info** `<SUPPLINF>` — contains publication data about
the SORN

**Privacy act** `<PRIACT>` — contains the content of the SORN.

Within these tags, Each SORN section is labeled with header \<HD\> tags
which we use as the keys to structure the content. We parse these
section headings [<span class="underline">by name with
Regex</span>](https://github.com/18F/all_sorns/blob/main/app/models/sorn_xml_parser.rb),
and save all the paragraph \<P\> elements between the matched section
and the next heading.

A few SORNs have semantic tags for SORN subsections, and we use them
whenever available.

Some SORNs published with the action to modify an existing SORN only
contain the sections being modified, not the entire document. Some SORNs
contain several complete SORNs for several different systems. SORN DASH
does not currently have a way to handle SORN XML where multiple SORNs
are republished in full, and will only display one set of fields for the
whole document (though the whole document is saved as XML).

## Database Schema

SORNs can belong to multiple agencies. We use a “has and belongs to many”
relationship of SORNs to Agencies.

Agencies in the database are only those that have published a SORN in the
Federal Register, so it is not a complete list of all government
agencies.

Mentions are the links between SORNs. We use a “has and belongs to many”
relationship again.
