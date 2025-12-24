foreach ($aNode in $this.XML | Select-Xml //img) {
    if ($aNode.Node.src) {
        $aNode.Node
    }
}