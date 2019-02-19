cat <<EOF > /k8s_python/src/index.html
<!DOCTYPE html>
<html>
<body>
<link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
<body style="background-color:blue;font-size:50px;color:yellow;text-align:center">
<h1>
<b> 
Test Page <br/>
</h1>
</b>
<p>Hostname is:   $(hostname)</p>
<p>IP Address is: $(hostname -i)</p>
</body>
</html>
EOF
python /k8s_python/src/app/webserver.py