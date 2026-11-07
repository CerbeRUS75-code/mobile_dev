import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Миронов Никита Сергеевич')),
        body: const Gallery(),
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  static const images = [
    [
      'https://i.ibb.co/Pvkdc2Vp/6p-Sux-U0-M6sn-ZMo-GOz-M5-HOyd74m9gr-Gj-Ja-CZUR80e2r81hvd-LXMWLm-Rz-AVg8-X-VWMLi-Fqfhs-G1-YGqq5bh6-No-RDa.jpg',
      'https://i.ibb.co/Kp8tSWkK/J5f-WVv-QOz12vz8-Y5y-Si-Ruh0h8z-Cqq-Rc6-PSm-RZTUJn4-Cw5-Cmei6a-Fz6jo5-Yh-ANg-qw-Q8-zx5-CGUz-Frx6-Mqs-HSDHWH.jpg',
      'https://i.ibb.co/fVS3vG3h/lzmd-CGIxh6k-Dwbh-Ac900en-Gt40-QNj252mf-DUgbyr49tuamy-Lcs-PBCVF6-HCQxj-Xog6-Jy9-G9yxw-ZKkvi0cdj-Umi9gx.jpg',
    ],
    [
      'https://i.ibb.co/NdmfbtVj/qk-Gz1z-Ug-We-HPUpv-Hgh-P246cc-SHQqpwdv-QHSCAADrz-O4a-Eo-F9x1o-Dmbj8-DPhval-AAa-A2-EUxbz1-QKIthe-Zh-JZ8.jpg',
      'https://i.ibb.co/dw4jXh7x/t-Yq0-Ovmb55c-Cq9tw-C5-B8-EQCjg-Mz-Bj-XCw-M3-MSDs9-2-R5-RUi-URY0-KXPMq-TY7-Qet-ZBFPEWr0-Ja-Fd-E4-Mj-Nn-vv1-MXu.jpg',
      'https://i.ibb.co/RGcc00hK/LSLE2cr-S038-LPf-B5-Sflh-jw9vlsi-c0fog-Sy1-WIx-Vnio-MDt-Qud4fm-ENp-U7-Oa-SPYt-JSh-Q9-F3-REiqmjfnb-J4-Rz-BUA.jpg',
    ],
    [
      'https://i.ibb.co/JW7B3ZVW/qdu-Noswq-Xf9o-Zijds-TVMbj-Iv-C12nh-Vb-Mp-ULmhp-Qkkh7-N8-Rg-O7c-Wl1l-CWe9-Sv3ev-Qp-UFjfzkbb-Lin3-J3-Fou-Q.jpg',
      'https://i.ibb.co/GQHwd03T/u-Qk-COdwm-Jek-Tlw64-Blx-Col-Jwgqs-Pphiazj-No-Eao2yc-iu-T8r-O8m-Wv-Kx-O9-BTEt-TViw-Oh-Juf-Mg-vj-Kf-YMH.jpg',
      'https://i.ibb.co/NdBZPX24/C5-Zu-V1-U6y3-Dcc7f-Tenta-P85a-TRv-Vkc-LLJIKAFw-Tmy3-Ow-NHYPl-Ah-B7-TEo-R2dgv-Rs-Lcbdrw-Vd-D9-Enl-Jm-IT0tr.jpg',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final row in images)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final url in row)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
