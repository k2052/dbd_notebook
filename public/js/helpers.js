//makes sort ignore casing
function charOrdA(a, b) {
	a = a.toLowerCase(); b = b.toLowerCase();
	if (a>b) return 1;
	if (a <b) return -1;
	return 0; 
}

//makes array unique
function unique(a) {
   var r = new Array();
   o:for(var i = 0, n = a.length; i < n; i++)
   {
      for(var x = 0, y = r.length; x < y; x++)
      {
         if(r[x]==a[i]) continue o;
      }
      r[r.length] = a[i];
   }
   return r;
}