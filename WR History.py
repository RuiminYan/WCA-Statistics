# 先在MySQL Workbench中运行Ao4R.sql中的代码 (注意：代码最后应使用按日期排序), 导出csv, 重命名为Ao4R.csv, 放到D:\Jupyter Notebook\cubing\

# 无转换
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

# 将最终结果保存为CSV文件，分隔符为tab，不包含表头
filtered_df.to_csv(r'D:\Jupyter Notebook\cubing\firstCompAvg WR.csv', sep='\t', encoding='utf-8-sig', index=False, header=False)





#有转换
import pandas as pd

# 定义转换函数：将值转换为成绩
def value2result(value):
    if value == -1:
        return "DNF"
    elif value == -2:
        return "DNS"
    elif value == 0:
        return ""
    elif value <= 999999:
        if value < 6000:
            return f"{value / 100:.2f}"
        else:
            minutes = value // 6000
            seconds = (value // 100) % 60
            centiseconds = value % 100
            return f"{minutes}:{seconds:02}.{centiseconds:02}"
    elif value < 1000000000:
        DD = int(str(value)[:2])
        TTTTT = int(str(value)[2:7])
        MM = int(str(value)[-2:])
        solved = 99 - DD + MM
        missed = MM
        attempted = solved + missed
        if TTTTT == 99999:
            time = "?:??:??"
        else:
            hours = TTTTT // 3600
            minutes = (TTTTT // 60) % 60
            seconds = TTTTT % 60
            if hours == 0:
                time = f"{minutes}:{seconds:02}"
            else:
                time = f"{hours}:{minutes:02}:{seconds:02}"
        return f"{solved}/{attempted} {time}"
    else:
        truncated = str(value)[-9:]
        SS = int(truncated[:2])
        AA = int(truncated[2:4])
        TTTTT = int(truncated[4:])
        solved = 99 - SS
        attempted = AA
        if TTTTT == 99999:
            time = "?:??:??"
        else:
            hours = TTTTT // 3600
            minutes = (TTTTT // 60) % 60
            seconds = TTTTT % 60
            if hours == 0:
                time = f"{minutes}:{seconds:02}"
            else:
                time = f"{hours}:{minutes:02}:{seconds:02}"
        return f"{solved}/{attempted} {time}"

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
filtered_df = filtered_df.sort_values(by='firstCompAvg', ascending=True)

# 应用转换函数到firstCompAvg
filtered_df['firstCompAvg'] = filtered_df['firstCompAvg'].apply(value2result)

# 检查并应用转换函数到value1到value5列 (如果存在)
for i in range(1, 6):
    col_name = f'value{i}'
    if col_name in filtered_df.columns:
        filtered_df[col_name] = filtered_df[col_name].apply(value2result)

# 将最终结果保存为CSV文件，分隔符为tab，不包含表头
filtered_df.to_csv(r'D:\Jupyter Notebook\cubing\firstCompAvg WR.csv', sep='\t', encoding='utf-8-sig', index=False, header=False)


