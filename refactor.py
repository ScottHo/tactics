from pathlib import Path
import re
import sys

def test(m):
    print(m.group(0))
    if m.group(0)[:5] == "0.001":
        return m.group(0)
    return m.group(0)[:4]
print(sys.version_info)
pathlist = Path(".").glob('**/*.tscn')
for path in pathlist:
    file_data = ""
    with open(path, "r") as f:
        file_data = f.read()
        file_data = re.sub(r'\d\.\d{3,10}', test, file_data, flags = re.M)
    with open(path, "wb") as f:
        f.write(file_data.encode())



