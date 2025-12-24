describe MarkX {
    context 'Markdown and XML' {
        it 'Gets markdown as XML' {
            "# Hello world" | 
                MarkX | 
                    Select-Object -ExpandProperty InnerText |
                        Should -Be 'Hello World'
        }

        it 'Can change' {
            $markx = "# Hello world" | MarkX
            
            $markx | 
                    Select-Object -ExpandProperty InnerText |
                        Should -Be 'Hello World'

            $markx.Markdown = '# I can change'
            $markx | 
                    Select-Object -ExpandProperty InnerText |
                        Should -Be 'I can change'
        }

        it 'Can contain tables' {
            $markx = "|a|b|c|","|-|-|-|", "|1|2|3|" | MarkX 
            
            $markx.DB.Tables[0].Rows[0].a | Should -Be 1
            $markx.DB.Tables[0].Columns[0].DataType | Should -Not -Be ([string])
            
            $markx.DB.Tables[0].Rows[0].b | Should -Be 2
            
            $markx.DB.Tables[0].Rows[0].c | Should -Be 3
        }
    }

}
