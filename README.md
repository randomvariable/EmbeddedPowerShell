Embedded PowerShell
===================

A port of ERB to PowerShell. For no apparent reason.

As said in the [Puppet documentation](http://docs.puppetlabs.com/guides/templating.html):

**EPS1 is Plain Text With Embedded PowerShell**

This script processes "eps1" files in a similar fashon to Embedded Ruby
Templating (as used by Puppet).

There isn't much logic involved - any expressions will be evaluated
as normal PowerShell.

To run
------

Expand EPS1 templates using the following command:


	.\Expand-EPS1.ps1 -Text $texttoprocess

EPS1 Syntax
-----------

*[From the Puppet Docs](http://docs.puppetlabs.com/guides/templating.html)*

* `<%= PowerShell expression %>` — This tag will be replaced with the value
 of the expression it contains.

* `<% PowerShell code %>` — This tag will execute the code it contains, but
 will not be replaced by a value. Useful for conditional or looping
 logic, setting variables, and manipulating data before printing it.

* `<%# comment %>` — Anything in this tag will be suppressed in the final
 output.

* `<%% or %%>` — A literal `<%` or `%>`, respectively.

* `<%-` — Same as `<%`, but suppresses any leading whitespace in the final
 output. Useful when indenting blocks of code for readability.

* `-%>` — Same as `%>`, but suppresses the subsequent line break in the final
 output. Useful with many lines of non-printing code in a row, which
 would otherwise appear as a long stretch of blank lines.

The code is very loosely based upon
[http://blogs.msdn.com/b/mwilbur/archive/2007/03/14/powershell-template-engine.aspx](http://blogs.msdn.com/b/mwilbur/archive/2007/03/14/powershell-template-engine.aspx).

[Apache 2.0 License](https://github.com/randomvariable/EmbeddedPowerShell/blob/master/LICENSE)