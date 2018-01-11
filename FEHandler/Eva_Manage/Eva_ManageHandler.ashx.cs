using FEBLL;
using FEModel;
using FEModel.Entity;
using FEModel.Enum;
using FEUtility;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace FEHandler.Eva_Manage
{
    /// <summary>
    /// Eva_ManageHandler 的摘要说明
    /// </summary>
    public partial class Eva_ManageHandler : IHttpHandler
    {
        #region 字段

        /// <summary>
        /// 数据传输对象
        /// </summary>
        JsonModel jsonModel = new JsonModel();

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #endregion

        #region 中心入口点

        /// <summary>
        /// 中心入口点
        /// </summary>
        /// <param name="context"></param>
        public void ProcessRequest(HttpContext context)
        {
            HttpRequest Request = context.Request;

            //清除缓存【自动判断是否清除】
            Constant.Dispose_All();
            string func = RequestHelper.string_transfer(Request, "func");
            try
            {
                switch (func)
                {
                    #region 学年学期

                    //获取学年学期
                    case "Get_StudySection": Get_StudySection(context); break;
                    //添加学年学期
                    case "Add_StudySection": Add_StudySection(context); break;

                    #endregion

                    #region 指标库

                    //获取指标库分类
                    case "Get_IndicatorType": Get_IndicatorType(context); break;
                    //新增指标库分类
                    case "Add_IndicatorType": Add_IndicatorType(context); break;
                    //编辑指标库分类
                    case "Edit_IndicatorType": Edit_IndicatorType(context); break;
                    //删除指标库分类
                    case "Delete_Indicator_Type": Delete_Indicator_Type(context); break;

                    //获取指标库
                    case "Get_Indicator": Get_Indicator(context); break;
                    //新增指标库
                    case "Add_Indicator": Add_Indicator(context); break;
                    //编辑指标库
                    case "Edit_Indicator": Edit_Indicator(context); break;
                    //删除指标库
                    case "Delete_Indicator": Delete_Indicator(context); break;

                    #endregion

                    #region 表格

                    //获取表格
                    case "Get_Eva_Table": Get_Eva_Table(context); break;

                    //获取表格
                    case "Get_Eva_Table_S": Get_Eva_Table_S(context); break;


                    //获取表格详情
                    case "Get_Eva_TableDetail": Get_Eva_TableDetail(context); break;
                    //添加表格
                    case "Add_Eva_Table": Add_Eva_Table(context); break;
                    //复制表格
                    case "Copy_Eva_Table": Copy_Eva_Table(context); break;

                    //编辑表格
                    case "Edit_Eva_Table": Edit_Eva_Table(context); break;

                    //编辑表格
                    case "Enable_Eva_Table": Enable_Eva_Table(context); break;
                    //删除表格
                    case "Delete_Eva_Table": Delete_Eva_Table(context); break;
                    //获取表格头部
                    case "Get_Eva_Table_Header_Custom_List": Get_Eva_Table_Header_Custom_List(context); break;

                    #endregion

                    #region 课程

                    //获取课程类型
                    case "GetCourse_Type": GetCourse_Type(context); break;
                    //获取课程类型（包含设计表）
                    case "GetTable_ByCourseType": GetTable_ByCourseType(context); break;

                    #endregion

                    #region 任务分配

                    //获取教师、课程、授课班
                    case "GetTeacherInfo_Course_Cls": GetTeacherInfo_Course_Cls(context); break;

                    case "AddExpert_List_Teacher_Course": AddExpert_List_Teacher_Course(context); break;

                    case "DeleteExpert_List_Teacher_Course": DeleteExpert_List_Teacher_Course(context); break;

                    #endregion
                    
                    #region 定期设置

                    case "Get_Eva_Regular": Get_Eva_Regular(context); break;
                    case "Get_Eva_Regular_Select": Get_Eva_Regular_Select(context); break;
                        
                    case "Get_Eva_RegularS": Get_Eva_RegularS(context); break;
                    case "Get_Eva_RegularSingle": Get_Eva_RegularSingle(context); break;
                    case "Get_Eva_RegularData": Get_Eva_RegularData(context); break;
                    //筛选
                    case "Get_Eva_RegularDataSelect": Get_Eva_RegularDataSelect(context); break;
                    case "Get_Eva_RegularData_Room": Get_Eva_RegularData_Room(context); break;
                    case "Get_Eva_RegularData_RoomDetailList": Get_Eva_RegularData_RoomDetailList(context); break;
                    case "Get_Eva_RoomDetailAnswerList": Get_Eva_RoomDetailAnswerList(context); break;

                    case "Get_Backlog": Get_Backlog(context); break;
                        

                    //新增定期评价
                    case "Add_Eva_Regular": Add_Eva_Regular(context); break;
                    //编辑定期评价
                    case "Edit_Eva_Regular": Edit_Eva_Regular(context); break;
                    //删除定期评价
                    case "Delete_Eva_Regular": Delete_Eva_Regular(context); break;
                    //获取评价名称【定期评价】
                    case "Get_Eva_Regular_Name": Get_Eva_Regular_Name(context); break;

                    #endregion

                    #region 答题

                    //定期评价-答题
                    case "Add_Eva_QuestionAnswer": Add_Eva_QuestionAnswer(context); break;
                    case "Edit_Eva_QuestionAnswer": Edit_Eva_QuestionAnswer(context); break;
                    case "Remove_Eva_QuestionAnswer": Remove_Eva_QuestionAnswer(context); break;
                    case "Change_Eva_QuestionAnswer_State": Change_Eva_QuestionAnswer_State(context); break;
                                                
                    //定期评价-答题获取
                    case "Get_Eva_QuestionAnswer": Get_Eva_QuestionAnswer(context); break;
                    //定期评价-答题获取
                    case "Get_Eva_QuestionAnswerDetail": Get_Eva_QuestionAnswerDetail(context); break;

                
                    #endregion

                    #region other

                    //获取当前教师的班级
                    case "Get_Teacher_Class": Get_Teacher_Class(context); break;
                                             

                    //判断是否有专家定期评价的数据
                    case "CheckHasExpertRegu": CheckHasExpertRegu(context); break;

                    #endregion

                    #region 课程类型——表

                    case "GetCourseType_Table": GetCourseType_Table(context); break;
                    //添加
                    case "AddCourseType_Table": AddCourseType_Table(context); break;
                    //删除
                    case "DeleteCourseType_Table": DeleteCourseType_Table(context); break;

                    #endregion

                    default:
                        jsonModel = JsonModel.get_jsonmodel(5, "没有此方法", "");
                        context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                        break;
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                jsonModel = JsonModel.get_jsonmodel(7, "出现异常,请通知管理员", "");
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion
    }
}



