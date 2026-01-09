
# Hello World

## Greetings from MarkX!


[![MarkX PowerShell Gallery](https://img.shields.io/powershellgallery/dt/MarkX)](https://www.powershellgallery.com/packages/MarkX/)


### What Is MarkX?

MarkX is a useful little tool built around a useful little trick.

Markdown is text that turns into nicely balanced and escaped HTML.

We can put that HTML into any `<tag>` and treat it as `<xml>`.

This lets us query and manipulate markdown, giving us the best of both worlds.

It's easy to write text, and an easy to read document tree.


### Installing and Importing

You can install MarkX from the PowerShell Gallery, using `Install-Module`:

~~~PowerShell
Install-Module MarkX
~~~

Once install, you can import it with `Import-Module`

~~~PowerShell
Import-Module MarkX
~~~


### Getting Started

Let's start simple, by making some markdown:


~~~PowerShell
"# Hello World" | MarkX
~~~

When we run this, we should see two properties:  Markdown and XML.

Whenever we change the Markdown, everything else is updated.


### Getting Links

Let's see how this can be useful, by getting some links.

~~~PowerShell

$markXLinks =
"* [My Website](https://MrPowerShell.com/)",
"* [GitHub](https://github.com/StartAutomating)",
"* [BlueSky](https://bsky.app/profile/mrpowershell.com)" | 
    markx

@($markXLinks.Links.Href |        
    ForEach-Object { 
        "* $($_)"
    }) -join [Environment]::NewLine

~~~

When we run this, we get:

* https://MrPowerShell.com/
* https://github.com/StartAutomating
* https://bsky.app/profile/mrpowershell.com


### Getting Images

Let's see how this can be fun, by getting some images.

~~~PowerShell


$markXImages =
"* ![Mind Blown Stranger Things](https://media1.tenor.com/m/rReKAT-J3nsAAAAd/mind-blown-boom.gif)",
    "* ![Mind Blown Big Mouth](https://media1.tenor.com/m/rD98-O3i1xYAAAAC/what-mind-blown.gif)"
     | markx
@(
$markXImages

$markXImages.Images |        
    ForEach-Object { 
        "* [$($_.alt)]($($_.src))"
    }
) -join [Environment]::NewLine


~~~

When we run this, we get:

<ul><li><img src="https://media1.tenor.com/m/rReKAT-J3nsAAAAd/mind-blown-boom.gif" alt="Mind Blown Stranger Things" /></li><li><img src="https://media1.tenor.com/m/rD98-O3i1xYAAAAC/what-mind-blown.gif" alt="Mind Blown Big Mouth" /></li></ul>

* [Mind Blown Stranger Things](https://media1.tenor.com/m/rReKAT-J3nsAAAAd/mind-blown-boom.gif)
* [Mind Blown Big Mouth](https://media1.tenor.com/m/rD98-O3i1xYAAAAC/what-mind-blown.gif)


### Making Tables 

Let's make some tables

~~~PowerShell


$timesTable = @(
    "#### TimesTable"
    foreach ($rowN in 1..9) {
        $row = [Ordered]@{}
        foreach ($colN in 1..9) {
            $row["$colN"] = $colN * $rowN
        }
        $row
    }
) | MarkX

$timesTable


~~~

When we run this, we get:

<h4 id="timestable">TimesTable</h4><table><thead><tr><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>8</th><th>9</th></tr></thead><tbody><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td></tr><tr><td>2</td><td>4</td><td>6</td><td>8</td><td>10</td><td>12</td><td>14</td><td>16</td><td>18</td></tr><tr><td>3</td><td>6</td><td>9</td><td>12</td><td>15</td><td>18</td><td>21</td><td>24</td><td>27</td></tr><tr><td>4</td><td>8</td><td>12</td><td>16</td><td>20</td><td>24</td><td>28</td><td>32</td><td>36</td></tr><tr><td>5</td><td>10</td><td>15</td><td>20</td><td>25</td><td>30</td><td>35</td><td>40</td><td>45</td></tr><tr><td>6</td><td>12</td><td>18</td><td>24</td><td>30</td><td>36</td><td>42</td><td>48</td><td>54</td></tr><tr><td>7</td><td>14</td><td>21</td><td>28</td><td>35</td><td>42</td><td>49</td><td>56</td><td>63</td></tr><tr><td>8</td><td>16</td><td>24</td><td>32</td><td>40</td><td>48</td><td>56</td><td>64</td><td>72</td></tr><tr><td>9</td><td>18</td><td>27</td><td>36</td><td>45</td><td>54</td><td>63</td><td>72</td><td>81</td></tr></tbody></table>



### Tables Become Data

Ok, this gets really cool.

_Tables become data_!

Because we can easily extract out the `<table>` elements inside of markdown, we can turn it into data.

And because the .NET framework includes a nifty in-memory database, we can turn this into something we can query.

#### The Nearest Heading Is The Table Name
> A blockquote is the description

|a|b|c|
|-|-|-|
|1|2|3|

~~~PowerShell


$markxTables = @'
#### abc
|a|b|c|
|-|-|-|
|1|2|3|
|4|5|6|
|7|8|9|

#### def

|d|e|f|
|-|-|-|
|1|2|3|
|2|4|6|
|3|6|9|
|4|8|12|

'@ | MarkX 
$markxTables
$markxTables.DB.Tables["abc"].Compute('sum(a)','') # | Should -Be 12    
$markxTables.DB.Tables["def"].Compute('sum(d)','') # | Should -Be 10

~~~

When we run this example, we get:

<h4 id="abc">abc</h4><table><thead><tr><th>a</th><th>b</th><th>c</th></tr></thead><tbody><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td></tr></tbody></table><h4 id="def">def</h4><table><thead><tr><th>d</th><th>e</th><th>f</th></tr></thead><tbody><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>2</td><td>4</td><td>6</td></tr><tr><td>3</td><td>6</td><td>9</td></tr><tr><td>4</td><td>8</td><td>12</td></tr></tbody></table>
 12 10



### Markdown Lexicons

Since we can extra tables and data Markdown, we can also get any data of a particular known shape.

The first special shape MarkX supports is an [at protocol lexicon](https://atproto.com/guides/lexicon)

MarkX current supports lexicon type definitions.  It will support query and procedure definitions in the future.

A type definition consists of a namespace identifier, a description, and a series of properties.

#### com.example.happy.birthday
> An example lexicon to record birthday messages

|Property|Type|Description|
|-|-|-|
|`$type`      | `[string]`   | The type of the object.  Must be `com.example.happy.birthday` |
|**`message`**| `[string]`   | A birthday message |
|`forUri`     | `[uri]`      | A link |
|`birthday`   | `[datetime]` | The birthday |
|`createdAt`  | `[datetime]` | The time the record was created |



To extract out a lexicon from the text above, we can:

~~~PowerShell
$lexiconMarkdown.Lexicon | ConvertTo-Json -Depth 5
~~~

Which gives us:

~~~json
{
  "lexicon": 1,
  "id": "com.example.happy.birthday",
  "defs": {
    "main": {
      "type": "record",
      "description": "com.example.happy.birthday",
      "required": [
        "message"
      ],
      "properties": {
        "message": {
          "type": "string",
          "description": "A birthday message"
        },
        "forUri": {
          "type": "uri",
          "description": "A link"
        },
        "birthday": {
          "type": "datetime",
          "description": "The birthday"
        },
        "createdAt": {
          "type": "datetime",
          "description": "The time the record was created"
        }
      }
    }
  }
}
~~~

As you can see, we can take rich data within Markdown and process it into lexicons (or anything else we might want)
# Get-MarkX
## Gets MarkX
### Gets MarkX - Markdown as XML

This allows us to query, extract, and customize markdown.

'Hello World' In Markdown / MarkX
~~~PowerShell
'# Hello World' | MarkX
~~~
MarkX is aliased to Markdown
'Hello World' as Markdown as XML
~~~PowerShell
'# Hello World' | Markdown | Select -Expand XML
~~~
We can generate tables by piping in objects
~~~PowerShell
@{n1=1;n2=2}, @{n1=2;n3=3} | MarkX
~~~
Make a TimesTable in MarkX
~~~PowerShell
@(
    "#### TimesTable"
    foreach ($rowN in 1..9) {
        $row = [Ordered]@{}
        foreach ($colN in 1..9) {
            $row["$colN"] = $colN * $rowN
        }
        $row
    }
) | Get-MarkX
~~~
We can pipe a command into MarkX
This will get the command help as Markdown
~~~PowerShell
Get-Command Get-MarkX | MarkX
~~~
We can pipe help into MarkX
~~~PowerShell
Get-Help Get-MarkX | MarkX
~~~

## In Summary

MarkX is a simple and powerful tool.
It allows us to turn many objects into Markdown, and turn Markdown into many objects.

Please pay around and see what you can do.

