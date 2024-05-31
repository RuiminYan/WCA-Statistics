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
filtered_df.to_csv('filtered_output_file.csv', sep=',', encoding='utf-8-sig', index=False)
