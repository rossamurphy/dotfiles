set up venv
```bash
venvcreate
venvactivate
```
install jupyter
```
pip install jupyter lab
pip install ipykernel
```
set up venv for use with jupyter
```bash
python -m ipykernel install --user --name=VENV_NAME
```

open jupyter and select the kernel
```bash
jupyter lab
```

disconnect the venv from jupyer
```bash
jupyter-kernelspec uninstall VENV_NAME
```

