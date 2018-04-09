using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Enum
{
    public enum Question_Type
    {
        /// <summary>
        /// 选择题
        /// </summary>
        select = 1,
        /// <summary>
        /// 多选
        /// </summary>
        multiselect=2,
        /// <summary>
        /// 问答题
        /// </summary>
        answer = 3,
        /// <summary>
        /// 评分题
        /// </summary>
        scoreSelect = 4,
    }
}
