# 这里以Ao4R WR History为例. 先在MySQL Workbench中运行Ao4R.sql中的代码 (注意：代码最后应使用按日期排序), 导出csv, 重命名为Ao4R.csv, 放到D:\Jupyter Notebook\cubing\

import pandas as pd

# 读取CSV文件
df = pd.read_csv(r'D:\Jupyter Notebook\Ao4R.csv', sep=',')

# 过滤数据
filtered_df = [df.iloc[0]]  # 保留第一行数据
for i in range(1, len(df)):
    if df.loc[i, 'Ao4R'] <= filtered_df[-1]['Ao4R']:
        filtered_df.append(df.iloc[i])

# 将结果保存为CSV文件
filtered_df = pd.DataFrame(filtered_df)
filtered_df.to_csv(r'D:\Jupyter Notebook\Ao4R WR.csv', sep=',', encoding='utf-8-sig', index=False)
