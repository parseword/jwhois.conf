# A modern jwhois.conf

**`jwhois.conf`** is the configuration file for the [jwhois](https://github.com/jonasob/jwhois/) WHOIS client.

Here, you can find a fork of `jwhois.conf` which has been made relatively current and is actively maintained. (This 
repository is not affiliated with jwhois or its authors.)

Please [open a new issue](https://github.com/parseword/jwhois.conf/issues/new) to submit an update or correction.

## Objective

Although jwhois is a popular program, and is even the default WHOIS client on some operating systems, the official
`jwhois.conf` distribution files <sup>**[\[1\]](#user-content-footnote1)** **[\[2\]](#user-content-footnote2)**</sup>
haven't been updated in many years. Various users have provided updates, some as patches to OS-specific jwhois 
distributions, others on GitHub and various forums and blogs. Few of these appear to have made it upstream, or into any 
one iteration of `jwhois.conf`.

The goal of this fork is to provide a stable and reliable repository for ongoing updates to `jwhois.conf`.

## Methodology

Here's an overview of how the `jwhois.conf` in this repository is put together:

1. The `jwhois.conf` from Fedora 36 <sup>**[\[3\]](#user-content-footnote3)**</sup> was chosen as a starting point,
because it had seen more recent updates compared to any official release.

2. An effort was made to locate outstanding discrepancies which have been reported by users to public forums; for 
example, the official jwhois GitHub issue tracker, the Red Hat Bugzilla, Stack Overflow, Ask Fedora, and others. These
updates were verified and manually merged into the file.

3. IANA <sup>**[\[4\]](#user-content-footnote4)**</sup> and ICANN <sup>**[\[5\]](#user-content-footnote5)**</sup> both
publish data describing the TLDs currently in use and, to some extent, the WHOIS facilities offered for each TLD. This
data is automatically processed on a weekly basis to discover new or terminated TLDs and other changes that should be 
reflected in the `whois-servers { }` stanza.

4. The Regional Internet Registries (AFRINIC, APNIC, ARIN, LACNIC, and RIPE) publish data files indicating which
portions of the IP space are managed by each Registry. This data is automatically processed on a daily basis to 
populate most of the `cidr-blocks { }` stanza. CIDRs are aggregated to produce the shortest possible accurate 
configuration.

5. Changes discovered by the automated processes described above are manually reviewed prior to being committed.
Some manual overrides have been put in place to supersede faulty or missing data.

6. Please [open a new issue](https://github.com/parseword/jwhois.conf/issues/new) to submit an update or correction.

## Files in this repository

Most users will only need...

* `jwhois.conf`: The latest version of the full configuration file. This is a drop-in replacement for the existing file
on your server.

If your environment has existing customizations for jwhois, like enabling the cache or setting a connection timeout,
you can create your own custom "stub" file and run the builder script so your changes are preserved. The necessary
files are in the `components` directory:

* `components/build-jwhois-conf.sh`: A bash script that will assemble a configuration file from the latest components.

* `components/jwhois.conf.stub`: A "stub" file without fully populated `whois-servers { }` or `cidr-blocks { }` stanzas,
but with placeholders so the build script can merge in the correct records.

* `components/records-ipv4-cidrs.txt`: The RIR IPv4 CIDR assignment records for the `cidr-blocks { }` stanza.

* `components/records-tlds-slds.txt`:The TLD and SLD WHOIS records for the `whois-servers { }` stanza.

To create your own "stub" file, copy `jwhois.conf.stub` to `jwhois.conf.stub.local` and add your custom settings there.
Running the `build-jwhois-conf.sh` script will assemble a configuration file from your local stub. You'll want to check
out the repository and periodically run `git pull` so that the latest changes to the component files are picked up.

## Caveats

Not every existing TLD can be supported. Some registrars restrict their port 43 WHOIS service to authorized users (e.g.
domain resellers). Others don't operate a traditional WHOIS service at all, requiring web-based lookups instead. Most
of these are noted in the `jwhois.conf` file with a corresponding comment. Please open a new issue if you'd like to 
submit an update or correction.

In cases where a WHOIS server CNAMEs to the underlying registrar, the in-bailiwick label is *usually* preferred. For 
example, the server for `academy` is specified as `whois.nic.academy`, even though that CNAMEs to `whois.donuts.co`.
Management of TLDs sometimes shifts between registrars; using an in-bailiwick label can make these transitions seamless.

At present, only IPv4 data from the Regional Internet Registries is being automatically processed. The IPv6 portion
of the `cidr-blocks { }` stanza remains largely as-is from the forked Fedora 36 `jwhois.conf`.

## References

<a id="user-content-footnote1"></a>1. jwhois.conf [on savannah.gnu.org](http://savannah.gnu.org/cgi-bin/viewcvs/jwhois/jwhois/example/jwhois.conf), last updated 2011-04-14    
<a id="user-content-footnote2"></a>2. jwhois.conf [on GitHub](https://github.com/jonasob/jwhois/blob/master/example/jwhois.conf), last updated 2015-10-24    
<a id="user-content-footnote3"></a>3. jwhois.conf [from Fedora 36](https://src.fedoraproject.org/rpms/jwhois/blob/f36/f/jwhois.conf), last updated 2021-11-03     
<a id="user-content-footnote4"></a>4. https://data.iana.org/TLD/tlds-alpha-by-domain.txt    
<a id="user-content-footnote5"></a>5. ["Registry Listings - ICANN"](https://www.icann.org/resources/pages/listing-2012-02-25-en)
