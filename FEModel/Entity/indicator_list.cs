using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    /// <summary>
    /// 表格设计用
    /// </summary>
    public class indicator_list
    {
        /// <summary>
        /// Id
        /// </summary>
        public long Id { get; set; }

        public decimal OptionF_S_Max { get; set; }

        /// <summary>
        /// 教师对学生要求严格。
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// IndicatorType_Id
        /// </summary>
        public long IndicatorType_Id { get; set; }

        public string IndicatorType_Name { get; set; }

        /// <summary>
        /// QuesType_Id
        /// </summary>
        public long QuesType_Id { get; set; }
        /// <summary>
        /// 优
        /// </summary>
        public string OptionA { get; set; }
        /// <summary>
        /// 良
        /// </summary>
        public string OptionB { get; set; }
        /// <summary>
        /// 中
        /// </summary>
        public string OptionC { get; set; }
        /// <summary>
        /// 差
        /// </summary>
        public string OptionD { get; set; }
        /// <summary>
        /// 很差
        /// </summary>
        public string OptionE { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionF { get; set; }
        /// <summary>
        /// UseTimes
        /// </summary>
        public long UseTimes { get; set; }
        /// <summary>
        /// 理论课（专家用）
        /// </summary>
        public string Remarks { get; set; }
        /// <summary>
        /// 2017001
        /// </summary>
        public string CreateUID { get; set; }
        /// <summary>
        /// /Date(1489547328447)/
        /// </summary>
        public string CreateTime { get; set; }
        /// <summary>
        /// 001
        /// </summary>
        public string EditUID { get; set; }
        /// <summary>
        /// /Date(1489547328447)/
        /// </summary>
        public string EditTime { get; set; }
        /// <summary>
        /// IsEnable
        /// </summary>
        public long IsEnable { get; set; }
        /// <summary>
        /// IsDelete
        /// </summary>
        public long IsDelete { get; set; }
        /// <summary>
        /// Flg
        /// </summary>
        public long flg { get; set; }
        /// <summary>
        /// 1
        /// </summary>
        public string OptionA_S { get; set; }
        /// <summary>
        /// 2
        /// </summary>
        public string OptionB_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionC_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionD_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionE_S { get; set; }

        /// <summary>
        /// 3
        /// </summary>
        public string OptionF_S { get; set; }

        /// <summary>
        /// 101
        /// </summary>
        public string Sort { get; set; }

        public int RootID { get; set; }

        public string Root { get; set; }

        public int Table_Id { get; set; }
    }
}
