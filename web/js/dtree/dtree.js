function Node(id, pid, name, url, title, target, icon, iconOpen, open) {
    this.id = id;
    this.pid = pid;
    this.name = name;
    this.url = url;
    this.title = title;
    this.target = target;
    this.icon = icon;
    this.iconOpen = iconOpen;
    this._io = open || false;
    this._is = false;
    this._ls = false;
    this._hc = false;
    this._ai = 0;
    this._p;
    this.select = false;
};

function dTree(objName) {
    this.config = {
        target: null,
        folderLinks: true,
        useSelection: true,
        useCookies: true,
        useLines: true,
        useIcons: true,
        useStatusText: false,
        closeSameLevel: false,
        inOrder: false,
        check: false, 
        checkOnClickType: '0', 
        ajaxTree: false,
        renderTo: '',
        ajaxUrl: '',
        treetype: '',
        params: '',
        iconFilePath: '../../js/dtree/img/'
    }
    this.icon = {
        root: this.config.iconFilePath+ 'base.gif',
        folder: this.config.iconFilePath+ 'folder.gif',
        folderOpen: this.config.iconFilePath+ 'folderopen.gif',
        node: this.config.iconFilePath+ 'page.gif',
        empty: this.config.iconFilePath+ 'empty.gif',
        line: this.config.iconFilePath+ 'line.gif',
        join: this.config.iconFilePath+ 'join.gif',
        joinBottom: this.config.iconFilePath+ 'joinbottom.gif',
        plus:  this.config.iconFilePath+ 'plus.gif',
        plusBottom:  this.config.iconFilePath+ 'plusbottom.gif',
        minus:  this.config.iconFilePath+ 'minus.gif',
        minusBottom:  this.config.iconFilePath+ 'minusbottom.gif',
        nlPlus:  this.config.iconFilePath+ 'nolines_plus.gif',
        nlMinus:  this.config.iconFilePath+ 'nolines_minus.gif'
    };
    this.obj = objName;
    this.aNodes = [];
    this.aIndent = [];
    this.aNodesData = [];
    this.root = new Node(-1);
    this.selectedNode = null;
    this.selectedFound = false;
    this.completed = false;
};

dTree.prototype.add = function(id, pid, name, url, title, target, icon, iconOpen, open) {
    this.aNodes[this.aNodes.length] = new Node(id, pid, name, url, title, target, icon, iconOpen, open);
};

dTree.prototype.addSpeNode = function(node) {
    this.aNodes[this.aNodes.length] = node;
};

dTree.prototype.openAll = function() {
    this.oAll(true);
};
dTree.prototype.closeAll = function() {
    this.oAll(false);
};

dTree.prototype.toString = function() {
    var str = '<div class="dtree">\n';
    if (document.getElementById) {
        if (this.config.useCookies) this.selectedNode = this.getSelected();
        str += this.addNode(this.root);
    } else str += 'Browser not supported.';
    str += '</div>';
    if (!this.selectedFound) this.selectedNode = null;
    this.completed = true;
    return str;
};

dTree.prototype.addNode = function(pNode) {
    var str = '';
    var n = 0;
    if (this.config.inOrder) n = pNode._ai;
    for (n; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == pNode.id) {
            var cn = this.aNodes[n];
            cn._p = pNode;
            cn._ai = n;
            this.setCS(cn);
            if (!cn.target && this.config.target) cn.target = this.config.target;
            if (cn._hc && !cn._io && this.config.useCookies) cn._io = this.isOpen(cn.id);
            if (!this.config.folderLinks && cn._hc) cn.url = null;
            if (this.config.useSelection && cn.id == this.selectedNode && !this.selectedFound) {
                cn._is = true;
                this.selectedNode = n;
                this.selectedFound = true;
            }
            str += this.node(cn, n);
            if (cn._ls) break;
        }
    }
    return str;
};

dTree.prototype.node = function(node, nodeId) {
    var str = '<div class="dTreeNode">' + this.indent(node, nodeId);
    if (this.config.useIcons) {
        if (!node.icon) node.icon = (this.root.id == node.pid) ? this.icon.root : ((node._hc) ? this.icon.folder : this.icon.node);
        if (!node.iconOpen) node.iconOpen = (node._hc) ? this.icon.folderOpen : this.icon.node;
        if (this.root.id == node.pid) {
            node.icon = this.icon.root;
            node.iconOpen = this.icon.root;
        }
        if (this.config.check == true) {
            str += '<input type="checkbox" id="check' + this.obj + nodeId + '" '+ (node.select?'checked="checked"':'') + ' onclick="javascript:' + this.obj + '.dTreeCheckbox(' + nodeId + ')"/>';
        }
        str += '<img id="i' + this.obj + nodeId + '" src="' + ((node._io) ? node.iconOpen : node.icon) + '" alt="" />';
    }
    if (node.url) {
        str += '<a id="s' + this.obj + nodeId + '" class="' + ((this.config.useSelection) ? ((node._is ? 'nodeSel' : 'node')) : 'node') + '" href="' + node.url + '"';
        if (node.title) str += ' title="' + node.title + '"';
        if (node.target) str += ' target="' + node.target + '"';
        if (this.config.useStatusText) str += ' onmouseover="window.status=\'' + node.name + '\';return true;" onmouseout="window.status=\'\';return true;" ';
        if (this.config.useSelection && ((node._hc && this.config.folderLinks) || !node._hc))
            str += ' onmousedown="javascript: ' + this.obj + '.s(' + nodeId + ');"';
        str += '>';
    }
    else if ((!this.config.folderLinks || !node.url) && node._hc && node.pid != this.root.id)
        str += '<a href="javascript: ' + this.obj + '.o(' + nodeId + ');" class="node">';
    str += node.name;
    if (node.url || ((!this.config.folderLinks || !node.url) && node._hc)) str += '</a>';
    str += '</div>';
    if (node._hc) {
        str += '<div id="d' + this.obj + nodeId + '" class="clip" style="display:' + ((this.root.id == node.pid || node._io) ? 'block' : 'none') + ';">';
        str += this.addNode(node);
        str += '</div>';
    }
    this.aIndent.pop();
    return str;
};

dTree.prototype.indent = function(node, nodeId) {
    var str = '';
    if (this.root.id != node.pid) {
        for (var n = 0; n < this.aIndent.length; n++)
            str += '<img src="' + ((this.aIndent[n] == 1 && this.config.useLines) ? this.icon.line : this.icon.empty) + '" alt="" />';
        (node._ls) ? this.aIndent.push(0) : this.aIndent.push(1);
        if (node._hc) {
            str += '<a href="javascript: ' + this.obj + '.o(' + nodeId + ');"><img id="j' + this.obj + nodeId + '" src="';
            if (!this.config.useLines) str += (node._io) ? this.icon.nlMinus : this.icon.nlPlus;
            else str += ((node._io) ? ((node._ls && this.config.useLines) ? this.icon.minusBottom : this.icon.minus) : ((node._ls && this.config.useLines) ? this.icon.plusBottom : this.icon.plus));
            str += '" alt="" /></a>';
        } else str += '<img src="' + ((this.config.useLines) ? ((node._ls) ? this.icon.joinBottom : this.icon.join) : this.icon.empty) + '" alt="" />';
    }
    return str;
};

dTree.prototype.setCS = function(node) {
    var lastId;
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == node.id) node._hc = true;
        if (this.aNodes[n].pid == node.pid) lastId = this.aNodes[n].id;
    }
    if (lastId == node.id) node._ls = true;
};

dTree.prototype.getSelected = function() {
    var sn = this.getCookie('cs' + this.obj);
    return (sn) ? sn : null;
};

dTree.prototype.s = function(id) {
    if (!this.config.useSelection) return;
    var cn = this.aNodes[id];
    if (cn._hc && !this.config.folderLinks) return;
    if (this.selectedNode != id) {
        if (this.selectedNode || this.selectedNode == 0) {
            eOld = document.getElementById("s" + this.obj + this.selectedNode);
            eOld.className = "node";
        }
        eNew = document.getElementById("s" + this.obj + id);
        eNew.className = "nodeSel";
        this.selectedNode = id;
        if (this.config.useCookies) this.setCookie('cs' + this.obj, cn.id);
    }
};

dTree.prototype.o = function(id) {
    var cn = this.aNodes[id];
    if(this.config.ajaxTree){  
        var subDIV = document.getElementById("d" + this.obj + id);
        if(subDIV != null && !subDIV.hasChildNodes()) {
            this.getData(cn.id);
        }
    }
    this.nodeStatus(!cn._io, id, cn._ls);
    cn._io = !cn._io;
    if (this.config.closeSameLevel) this.closeLevel(cn);
    if (this.config.useCookies) this.updateCookie();
};

dTree.prototype.oAll = function(status) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n]._hc && this.aNodes[n].pid != this.root.id) {
            this.nodeStatus(status, n, this.aNodes[n]._ls)
            this.aNodes[n]._io = status;
        }
    }
    if (this.config.useCookies) this.updateCookie();
};

dTree.prototype.openTo = function(nId, bSelect, bFirst) {
    if (!bFirst) {
        for (var n = 0; n < this.aNodes.length; n++) {
            if (this.aNodes[n].id == nId) {
                nId = n;
                break;
            }
        }
    }
    var cn = this.aNodes[nId];
    if (cn.pid == this.root.id || !cn._p) return;
    cn._io = true;
    cn._is = bSelect;
    if (this.completed && cn._hc) this.nodeStatus(true, cn._ai, cn._ls);
    if (this.completed && bSelect) this.s(cn._ai);
    else if (bSelect) this._sn = cn._ai;
    this.openTo(cn._p._ai, false, true);
};

dTree.prototype.closeLevel = function(node) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == node.pid && this.aNodes[n].id != node.id && this.aNodes[n]._hc) {
            this.nodeStatus(false, n, this.aNodes[n]._ls);
            this.aNodes[n]._io = false;
            this.closeAllChildren(this.aNodes[n]);
        }
    }
}

dTree.prototype.closeAllChildren = function(node) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == node.id && this.aNodes[n]._hc) {
            if (this.aNodes[n]._io) this.nodeStatus(false, n, this.aNodes[n]._ls);
            this.aNodes[n]._io = false;
            this.closeAllChildren(this.aNodes[n]);
        }
    }
}
dTree.prototype.nodeStatus = function(status, id, bottom) {
    eDiv = document.getElementById('d' + this.obj + id);
    eJoin = document.getElementById('j' + this.obj + id);
    if (this.config.useIcons) {
        eIcon = document.getElementById('i' + this.obj + id);
        eIcon.src = (status) ? this.aNodes[id].iconOpen : this.aNodes[id].icon;
    }
    eJoin.src = (this.config.useLines) ?
	((status) ? ((bottom) ? this.icon.minusBottom : this.icon.minus) : ((bottom) ? this.icon.plusBottom : this.icon.plus)) :
	((status) ? this.icon.nlMinus : this.icon.nlPlus);
    eDiv.style.display = (status) ? 'block' : 'none';
};

dTree.prototype.clearCookie = function() {
    var now = new Date();
    var yesterday = new Date(now.getTime() - 1000 * 60 * 60 * 24);
    this.setCookie('co' + this.obj, 'cookieValue', yesterday);
    this.setCookie('cs' + this.obj, 'cookieValue', yesterday);
};

dTree.prototype.setCookie = function(cookieName, cookieValue, expires, path, domain, secure) {
    document.cookie =
		escape(cookieName) + '=' + escape(cookieValue)
		+ (expires ? '; expires=' + expires.toGMTString() : '')
		+ (path ? '; path=' + path : '')
		+ (domain ? '; domain=' + domain : '')
		+ (secure ? '; secure' : '');
};

dTree.prototype.getCookie = function(cookieName) {
    var cookieValue = '';
    var posName = document.cookie.indexOf(escape(cookieName) + '=');
    if (posName != -1) {
        var posValue = posName + (escape(cookieName) + '=').length;
        var endPos = document.cookie.indexOf(';', posValue);
        if (endPos != -1) cookieValue = unescape(document.cookie.substring(posValue, endPos));
        else cookieValue = unescape(document.cookie.substring(posValue));
    }
    return (cookieValue);
};

dTree.prototype.updateCookie = function() {
    var str = '';
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n]._io && this.aNodes[n].pid != this.root.id) {
            if (str) str += '.';
            str += this.aNodes[n].id;
        }
    }
    this.setCookie('co' + this.obj, str);
};

dTree.prototype.isOpen = function(id) {
    var aOpen = this.getCookie('co' + this.obj).split('.');
    for (var n = 0; n < aOpen.length; n++)
        if (aOpen[n] == id) return true;
    return false;
};

if (!Array.prototype.push) {
    Array.prototype.push = function array_push() {
        for (var i = 0; i < arguments.length; i++)
            this[this.length] = arguments[i];
        return this.length;
    }
};
if (!Array.prototype.pop) {
    Array.prototype.pop = function array_pop() {
        lastElement = this[this.length - 1];
        this.length = Math.max(this.length - 1, 0);
        return lastElement;
    }
};
dTree.prototype.show = function(did){     
    var aNodesData = this.aNodes; 
    //    alert(aNodesData);     
    this.aNodes=new Array();     
    this.aIndent=new Array();
    // Dump original data to aNode array
    for (var i = 0; i < aNodesData.length; i++) {
        var oneNode = aNodesData[i];
        this.aNodes[i] = new Node(oneNode.id, oneNode.pid, oneNode.name, oneNode.url, oneNode.title, oneNode.target, oneNode.icon, oneNode.iconOpen, oneNode.open);
    }
    document.getElementById(did).innerHTML = d; 
};  
dTree.prototype.draw = function() {
    this.aNodesData = this.aNodes;
    this.aNodes = new Array();
    this.aIndent = new Array();
    for (var i = 0; i < this.aNodesData.length; i++) {
        var oneNode = this.aNodesData[i];
        var node = new Node(oneNode.id, oneNode.pid, oneNode.name, oneNode.url, oneNode.title, oneNode.target, oneNode.icon, oneNode.iconOpen, oneNode.open);
        node._hc = oneNode._hc;
        this.aNodes[i] = node;
    }
    this.rewriteHTML();
};
dTree.prototype.draw = function(removeId, addParentId) {
    this.aNodesData = this.aNodes;
    this.aNodes = new Array();
    this.aIndent = new Array();
    for (var i = 0; i < this.aNodesData.length; i++) {
        var oneNode = this.aNodesData[i];
        var node = new Node(oneNode.id, oneNode.pid, oneNode.name, oneNode.url, oneNode.title, oneNode.target);
        if(this.config.ajaxTree){
            node._hc = oneNode._hc;
            node.open = oneNode.open;
            if(removeId == oneNode.id){
                node._hc = this.hasChildren(oneNode.id);                            
                if(!node._hc){
                    node.open = false;
                }
            }
            else if (addParentId == oneNode.id){
                node._hc = true;
            }
        }
        this.aNodes[i] = node;
    }
    this.rewriteHTML();
};
dTree.prototype.rewriteHTML = function() {
    var str = '';
    var container;
    container = document.getElementById(this.config.renderTo);
    if (!container) {
        alert('dTree can\'t find your specified container to show your tree.\n\n Please check your code!');
        return;
    }
    if (this.config.useCookies) 
        this.selectedNode = this.getSelected();
    str += this.addNode(this.root);
    if (!this.selectedFound) 
        this.selectedNode = null;
    this.completed = true;
    container.innerHTML = str;
};
dTree.prototype.hasChildren = function(id) { 
    for (var i = 0; i < this.aNodes.length; i++) { 
        var oneNode = this.aNodes[i];
        if (oneNode.pid == id) { return true; }  
    } 
    return false; 
};
dTree.prototype.isBeing = function(id) { 
    for (var i = 0; i < this.aNodes.length; i++) { 
        var oneNode = this.aNodes[i];
        if (oneNode.id == id) { return true; }  
    } 
    return false; 
};
Array.prototype.remove = function(dx) { 
    if (isNaN(dx) || dx > this.length) { 
        return false; 
    } 
    for (var i = 0, n = 0; i < this.length; i++) { 
        if (this[i] != this[dx]) { 
            this[n++] = this[i] 
        } 
    } 
    this.length -= 1 
};
dTree.prototype.remove = function(id) { 
    if (!this.hasChildren(id)) { 
        for (var i = 0; i < this.aNodes.length; i++) { 
            if (this.aNodes[i].id == id) { 
                this.aNodes.remove(i); 
                break;
            } 
        } 
    } 
};

dTree.prototype.dTreeCheckbox = function(nodeId) {
    if (this.config.checkOnClickType == '2') { 
        return;
    }
    //select status
    var selectType = document.getElementById("check" + this.obj + nodeId).checked;
    var n, node = this.aNodes[nodeId];
    //checkbox num
    var len = this.aNodes.length;
    //down
    for (n = 0; n < len; n++) {
        if (this.aNodes[n].pid == node.id) {
            document.getElementById("check" + this.obj + n).checked = selectType;
            this.dTreeCheckbox(n);
        }
    }

    if (this.config.checkOnClickType == '0') { 
        //up
        if (selectType == false) {
            var pid = node.pid;
            do {
                var bSearch = true;
                for (n = 0; n < len; n++) {
                    if (this.aNodes[n].id == pid) {
                        document.getElementById("check" + this.obj + n).checked = false;
                        pid = this.aNodes[n].pid;
                        break;
                    }
                }
            } while (pid != -1);
        }
        else {
            var pid = node.pid;
            do {
                var bSearch = true;
                for (n = 0; n < len; n++) {
                    if (this.aNodes[n].pid == pid && document.getElementById("check" + this.obj + n).checked == false) {
                        bSearch = false;
                        break;
                    }
                }
                for (j = 0; j < len; j++) {
                    if (this.aNodes[j].id == pid) {
                        document.getElementById("check" + this.obj + j).checked = bSearch;
                        pid = this.aNodes[j].pid;
                        break;
                    }
                }
            } while (pid != -1);
        }
    }
    else if (this.config.checkOnClickType == '1') { 
        //up
        if (selectType) {
            var pid = node.pid;
            do {
                var bSearch = true;
                for (n = 0; n < len; n++) {
                    if (this.aNodes[n].id == pid) {
                        document.getElementById("check" + this.obj + n).checked = true;
                        pid = this.aNodes[n].pid;
                        break;
                    }
                }
            } while (pid != -1);
        }
        else {
            var pid = node.pid;
            do {
                var bSearch = false;
                for (n = 0; n < len; n++) {
                    if (this.aNodes[n].pid == pid && document.getElementById("check" + this.obj + n).checked == true) {
                        bSearch = true;
                        break;
                    }
                }
                for (j = 0; j < len; j++) {
                    if (this.aNodes[j].id == pid) {
                        document.getElementById("check" + this.obj + j).checked = bSearch;
                        pid = this.aNodes[j].pid;
                        break;
                    }
                }
            } while (pid != -1);
        }
    }
};

dTree.prototype.getTreeCheckboxSelectValue = function() {  
    var selectValue = '';
    for (var n = 0; n < this.aNodes.length; n++) {
        if (document.getElementById("check" + this.obj + n).checked == true){
            selectValue += ',' + this.aNodes[n].id;
        }
    }
    if (selectValue.length > 0){
        selectValue = selectValue.substr(1);
    }
    return selectValue;
};

dTree.prototype.getTreeCheckboxSelectText = function() {  
    var selectValue = '';
    for (var n = 0; n < this.aNodes.length; n++) {
        if (document.getElementById("check" + this.obj + n).checked == true){
            selectValue += ',' + this.aNodes[n].name;
        }
    }
    if (selectValue.length > 0){
        selectValue = selectValue.substr(1);
    }
    return selectValue;
};

dTree.prototype.getTreeCheckboxSelectTextValue = function() {  
    var selectValue = '';
    var selectIds = '';
    for (var n = 0; n < this.aNodes.length; n++) {
        var input = document.getElementById("check" + this.obj + n);
        if(input != null){            
            if (input.checked == true){
                selectValue += ',' + this.aNodes[n].id + '|' + this.aNodes[n].name;
            }   
        }
    }
    if (selectValue.length > 0){
        selectValue = selectValue.substr(1);
    }
    return selectValue;
};

dTree.prototype.getData = function(id) {
    var d = this;
    var xmlHttp;
    if (window.ActiveXObject) {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if (window.XMLHttpRequest) {
        xmlHttp = new XMLHttpRequest();
    }
    var url = this.config.ajaxUrl;
    var queryString = "t=" + this.config.treetype + "&pid=" + id + "&params=" + this.config.params;
    xmlHttp.onreadystatechange = function() {
        if (4 == xmlHttp.readyState && 200 == xmlHttp.status) {
            var data = xmlHttp.responseText;
            var json = JSON.parse(data).data;
            for (var i = 0; i < json.length; i++) {
                if (d.config.ajaxTree) {
                    var node = new Node(json[i].Id, json[i].PId, json[i].Name, json[i].Url, json[i].Title, json[i].Target == "null" ? null : json[i].Target, json[i].Icon, json[i].OpenIcon, json[i].IsOpen == "open");
                    //node._hc = json[i].hc.trim().toLowerCase() == "true";
                    node._hc = json[i].hc.replace(' ','') == "true";
                    d.aNodes[d.aNodes.length] = node;
                }
                else {
                    d.add(json[i].Id, json[i].PId, json[i].Name, json[i].Url, json[i].Title, json[i].Target == "null" ? null : json[i].Target, json[i].Icon, json[i].OpenIcon, json[i].IsOpen == "open");
                }
            }
            //console.log("renderTo0:"+d.config.renderTo);
            document.getElementById(d.config.renderTo).innerHTML = d.toString();
        }
    }
    xmlHttp.open("POST", url);
    xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
    xmlHttp.send(encodeURI(queryString));
};

dTree.prototype.getData1 = function(id,rootId,rootName) {
    var d = this;
    //d.add(350125, rootId, rootName,"javascript:myOnClient('350125','永泰县')");  //添加根节点
    var xmlHttp;
    if (window.ActiveXObject) {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if (window.XMLHttpRequest) {
        xmlHttp = new XMLHttpRequest();
    }
    var url = this.config.ajaxUrl;
    var queryString = "t=" + this.config.treetype + "&pid=" + id + "&params=" + this.config.params;
    xmlHttp.onreadystatechange = function() {
        if (4 == xmlHttp.readyState && 200 == xmlHttp.status) {
            var data = xmlHttp.responseText;
            var json = JSON.parse(data).data;
            for (var i = 0; i < json.length; i++) {
                if (d.config.ajaxTree) {
                    var node = new Node(json[i].Id, json[i].PId, json[i].Name, json[i].Url, json[i].Title, json[i].Target == "null" ? null : json[i].Target, json[i].Icon, json[i].OpenIcon, json[i].IsOpen == "open");
                    //node._hc = json[i].hc.trim().toLowerCase() == "true";
                    node._hc = json[i].hc.replace(' ','') == "true";
                    d.aNodes[d.aNodes.length] = node;
                }
                else {
                    d.add(json[i].Id, json[i].PId, json[i].Name, json[i].Url, json[i].Title, json[i].Target == "null" ? null : json[i].Target, json[i].Icon, json[i].OpenIcon, json[i].IsOpen == "open");
                }
            }
            //console.log("renderTo:"+d.config.renderTo);
            document.getElementById(d.config.renderTo).innerHTML = d.toString();
        }
    }
    xmlHttp.open("POST", url);
    xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
    xmlHttp.send(encodeURI(queryString));
};
