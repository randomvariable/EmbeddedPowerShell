<#
.SYNOPSIS
    Processes a "Embedded PowerShell Template" into its completed text
    equivalent.

    As said in the Puppet documentation:

    EPS1 is Plain Text With Embedded PowerShell

.DESCRIPTION
    This script processes "eps1" files in a similar fashon to Embedded Ruby
    Templating (as used by Puppet).

    There isn't much logic involved - any expressions will be evaluated
    as normal PowerShell.

    EPS1 Syntax:
        (From the Puppet Docs)
        <%= PowerShell expression %> — This tag will be replaced with the value
        of the expression it contains.

        <% PowerShell code %> — This tag will execute the code it contains, but
        will not be replaced by a value. Useful for conditional or looping
        logic, setting variables, and manipulating data before printing it.

        <%# comment %> — Anything in this tag will be suppressed in the final
        output.

        <%% or %%> — A literal <% or %>, respectively.

        <%- — Same as <%, but suppresses any leading whitespace in the final
        output. Useful when indenting blocks of code for readability.

        -%> — Same as %>, but suppresses the subsequent line break in the final
        output. Useful with many lines of non-printing code in a row, which
        would otherwise appear as a long stretch of blank lines.

.NOTES
    The code is loosely based upon
    http://blogs.msdn.com/b/mwilbur/archive/2007/03/14/powershell-template-engine.aspx

    File Name: Expand-EPS1.ps1
    Author:    Naadir Jeewa (naadir [at] randomvariable [dot] co [dot] uk
    License:   Apache 2.0 License
               http://www.apache.org/licenses/LICENSE-2.0.html

.LINK
    
#>
param ($text) 

$executionTag = [regex]::escape("<%")
$printTag = [regex]::escape("<%=")
$endWithOutNewLineTag = [regex]::escape("-%>")
$literalBeginTag = [regex]::escape("<%%")
$literalEndTag = [regex]::escape("%%>")
$endWithNewLineTag = [regex]::escape("%>")
$commentTag = [regex]::escape("<%#")
$output=[string]""
$inputText=""
$text | %{$inputText+=[string]$_ + "`r"} 
$eps1regex = "(?m)(?<pre>.*?)(?<literal>$literalBeginTag|$literalEndTag|"+
        "(?<begintag>$printtag|$commentTag|$executiontag)(?<exp>.*?)" +
        "(?<endtag>$endWithNewLineTag|$endWithOutNewLineTag))(?<post>.*)"

while ($inputText -match $eps1regex)
{ 
  $inputText = $matches.post 
  $output += $matches.pre 
  switch($matches.literal)
  {
    "<%%"
    {
        $output+="<%"
    }
    "%%>"
    {
        $output+="%>"
    }
    default
    {
      switch($matches.begintag)
      {
	    "<%="
	    {
		    $output += invoke-expression $matches.exp
	    }
	    "<%#"
	    {
	    }
        "<%-"
        {
            $output.TrimEnd(" ")
            $output.TrimEnd("`t")
            Invoke-Expression $matches.exp | out-null
        }
	    "<%"
	    {
		    invoke-expression $matches.exp | out-null
	    }
      }
      switch ($matches.endtag)
      {
	    "%>"
	    {
		    if($matches.begintag -eq "<%")
            {
                $output +=  "`r"
            }
	    }
	    "-%>"
	    {
	    }
      }
    }
  }
} 
$output += $inputText
$output -replace "`r", [environment]::newline 

