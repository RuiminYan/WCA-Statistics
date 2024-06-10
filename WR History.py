# 这里以Ao4R WR History为例. 先在MySQL Workbench中运行Ao4R.sql中的代码 (注意：代码最后应使用按日期排序), 导出csv, 重命名为Ao4R.csv, 放到D:\Jupyter Notebook\cubing\

import pandas as pd

# 读取CSV文件
df = pd.read_csv(r'D:\Jupyter Notebook\cubing\firstCompAvg.csv', encoding='utf-8-sig', sep=',')

# 初步筛选数据
filtered_df = [df.iloc[0]]  # 保留第一行数据
for i in range(1, len(df)):
    if df.loc[i, 'firstCompAvg'] <= filtered_df[-1]['firstCompAvg']:
        filtered_df.append(df.iloc[i])

# 将初步筛选结果转换为DataFrame
filtered_df = pd.DataFrame(filtered_df)

# 进一步筛选：当name列的值相同时，只保留firstCompAvg最小的行
filtered_df = filtered_df.loc[filtered_df.groupby('name')['firstCompAvg'].idxmin()]

# 按firstCompAvg排序
filtered_df = filtered_df.sort_values(by='firstCompAvg')

# 将最终结果保存为CSV文件
filtered_df.to_csv(r'D:\Jupyter Notebook\cubing\firstCompAvg WR.csv', sep=',', encoding='utf-8-sig', index=False)
