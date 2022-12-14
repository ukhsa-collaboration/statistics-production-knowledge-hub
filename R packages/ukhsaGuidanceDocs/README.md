<h1 align="center">ukhsaGuidanceDocs</h1>

<p>This is an R package used to help create the guidance documents found on our <a href = "https://github.com/ukhsa-collaboration/statistics-production-knowledge-hub/blob/main/README.md">knowledge hub</a>.</p>

<p>Specifically, it is used to populate the version history at the top of each document, as well as handling citations and populating reference lists.</p>

<p>To install this package in R, use: <code>devtools::install_github("UKHSA-Statistics-Production/ukhsaGuidanceDocs", build_vignettes = T)</code></p>

<br>


<h2>Populating a version history table</h2>
<p>The <code>VersionHistory()</code> function will add a collapsible formatted table to your HTML output detailing a version history.</p>
<p>Add the following line of code at the bottom of your main YAML in the RMarkdown script. Each version should be passed to the function call as a new list, containing a date and a release note.</p>
<blockquote>
<p>versioncontrol: &quot;<code>`r guidanceDocs::VersionHistory( c('15/10/2022', 'Second release'), c('30/09/2022', 'Initial release')  )`</code>&quot;</p>
</blockquote>
<p>Within the HTML document template, <code>&lt;div id=&quot;versioncontrol&quot;&gt;$versioncontrol$&lt;/div&gt;</code> is then used to render the table. This is already in our HTML template (found in our guidance documents repository), if you are using that.</p>
</div>


<h2>Adding in-text citations and populating a reference list</h2>
<p>Somewhere near the start of your RMarkdown document, in a code chunk you need to call <code>SetUpReferenceList(.path=&quot;path/myspreadsheet.xlsx&quot;, .sheet=1)</code>, passing the filepath and sheet number to where your reference list is stored. We would recommend that this is called as part of your setup chunk.</p>
<p>Note that this spreadsheet must be formatted such that there is a list of titles in Column A, a list of URLs in Column B, and a list of row number IDs in Column C. Rows do not need to be in any particular order but each ID should be unique.</p>
<p>Within your text, wherever you want to add a citation, you should call <code>`r addRef(n)`</code>, replacing the 'n' with a row number ID from the spreadsheet. If you want to cite more than one source, seperate each number with a comma like this: <code>`r addRef(n, n)`</code>.</p>
<p>For example:</p>
<blockquote>
<p>This is a piece of text where I want to cite references found in rows 5 and 12 of the spreadsheet <code>`r addRef(5, 12)`</code>. I would then carry on with more text here, perhaps ending with another citation <code>`r addRef(6)`</code>.</p>
</blockquote>
<p>At the end of your RMarkdown document (or wherever you want the reference list to appear), simply call <code>`r AddReferenceList()`</code> to add the formatted reference list. This will also create an anchor which the citation links will point to.</p>
</div>

