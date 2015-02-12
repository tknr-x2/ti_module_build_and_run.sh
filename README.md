ti_module_build_and_run.sh
==============
Titanium module の動作確認を実機でもやりたかったので。
ti build っぽく使えます。

18行目の **TIMODULE_APP_PATH** を、環境に合わせて変更してください。

```bash
ti_module_build_and_run.sh -s 3.5.0.GA -T device -V [証明書] -P [プロビジョニングファイル]
```

シミュレータでも実行できます。

```bash
ti_module_build_and_run.sh -s 3.5.0.GA -C [シミュレータのUUDI]
```