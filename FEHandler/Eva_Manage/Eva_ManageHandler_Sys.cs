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
    partial class Eva_ManageHandler
    {
        #region 学年学期管理

        /// <summary>
        /// 获取学年学期
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_StudySection(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //返回学年学期
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", Constant.StudySection_List);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        //上锁
        static object obj_Add_StudySection = new object();
        /// <summary>
        /// 新增学年学期
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_StudySection(HttpContext context)
        {
            lock (obj_Add_StudySection)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                string Academic = RequestHelper.string_transfer(Request, "Academic");
                string Semester = RequestHelper.string_transfer(Request, "Semester");
                DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
                DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                string StudyDisPlayName = RequestHelper.string_transfer(Request, "StudyDisPlayName");
                try
                {
                    StudySection StudySectione_Add = new StudySection()
                    {
                        Academic = Academic,
                        Semester = Semester,
                        StartTime = StartTime,
                        EndTime = EndTime,

                        CreateTime = DateTime.Now,
                        CreateUID = CreateUID,
                        EditTime = DateTime.Now,
                        EditUID = EditUID,
                        IsEnable = (int)IsEnable.Enable,
                        DisPlayName = StudyDisPlayName,
                        IsDelete = (int)IsDelete.No_Delete
                    };
                    //数据库添加
                    jsonModel = new FEBLL.StudySectionService().Add(StudySectione_Add);
                    //从数据库返回的ID绑定
                    StudySectione_Add.Id = RequestHelper.int_transfer(Convert.ToString(jsonModel.retData));
                    if (jsonModel.errNum == intSuccess && !Constant.StudySection_List.Contains(StudySectione_Add))
                    {
                        //缓存添加
                        Constant.StudySection_List.Add(StudySectione_Add);
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        #endregion

        #region 获取课程类型


        /// <summary>
        ///获取课程类型
        /// </summary>
        public void GetCourse_Type(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //课程类型
            DictionType_Enum dictiontype = DictionType_Enum.Course_Type;
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            try
            {
                bool HasSection = RequestHelper.bool_transfer(Request, "HasSection");


                var list = (from dic in Constant.Sys_Dictionary_List
                            join section in Constant.StudySection_List on dic.SectionId equals section.Id
                            where dic.Type == Convert.ToString((int)dictiontype) && dic.SectionId == section.Id
                            orderby section.EndTime descending
                            select new CourseSection()
                            {
                                SectionId = dic.SectionId,
                                Sort = dic.Sort,
                                Type = dic.Type,
                                Value = dic.Value,
                                DisPlayName = section.DisPlayName,
                                CreateTime = section.CreateTime,
                                StartTime = section.StartTime,
                                EndTime = section.EndTime,
                                Id = dic.Id,
                                Key = dic.Key,
                                Pid = dic.Pid,
                                Study_IsEnable = section.IsEnable,
                                IsEnable = dic.IsEnable,
                                State = "",
                                ReguState = 0,
                            }).ToList();

                //带学年学期的课程
                if (HasSection)
                {
                    if (SectionId > 0)
                    {
                        list = (from li in list
                                where li.SectionId == SectionId
                                select li).ToList();
                    }
                }
                else
                {
                    StudySection section = Constant.StudySection_List.FirstOrDefault(item => item.IsEnable == 0);
                    if (section != null)
                    {
                        list = (from li in list
                                where section.Id == li.SectionId
                                select li).ToList();
                    }
                }

                ReguState regustate = ReguState.进行中;
                foreach (var li in list)
                {
                    if (li.StartTime < DateTime.Now && ((DateTime)li.EndTime).AddDays(1) > DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.StartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.State = Convert.ToString(regustate);
                    li.ReguState = (int)regustate;
                }
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        /// <summary>
        ///获取设计表【通过课程类型】
        /// </summary>
        public void GetTable_ByCourseType(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //课程类型
                //DictionType_Enum dictiontype = DictionType_Enum.Course_Type;
                int Eva_Role = RequestHelper.int_transfer(Request, "Eva_Role");
                List<Table_CourseType> Table_CourseType_List = new List<Table_CourseType>();


                List<Sys_Dictionary> list = (from dic in Constant.Sys_Dictionary_List
                                             where dic.Type == Convert.ToString((int)Dictionary_Type.Common_Course_Type)
                                             select dic).ToList();
                foreach (Sys_Dictionary item in list)
                {
                    Table_CourseType Table_CourseType = new Table_CourseType();
                    Table_CourseType.Course_Key = item.Key;
                    Table_CourseType.Course_Value = item.Value;
                    Table_CourseType.Eva_Role = Eva_Role;
                    Table_CourseType.Eva_Table_List = (from table in Constant.Eva_Table_List
                                                       where table.Eva_Role == Eva_Role && table.IsDelete == (int)IsDelete.No_Delete && table.IsEnable == (int)IsEnable.Enable
                                                      
                                                       select table).ToList();
                    Table_CourseType_List.Add(Table_CourseType);
                }


                if (Eva_Role == 2)
                {
                    List<Sys_Dictionary> list2 = (from dic in Constant.Sys_Dictionary_List
                                                  where dic.Type == Convert.ToString((int)Dictionary_Type.Edu_Course_Type)
                                                  select dic).ToList();
                    foreach (Sys_Dictionary item in list2)
                    {
                        Table_CourseType Table_CourseType = new Table_CourseType();
                        Table_CourseType.Course_Key = item.Key;
                        Table_CourseType.Course_Value = item.Value;
                        Table_CourseType.Eva_Role = 3;
                        Table_CourseType.Eva_Table_List = (from table in Constant.Eva_Table_List
                                                           where table.Eva_Role == Eva_Role && table.IsEnable == (int)IsEnable.Enable
                                                           select table).ToList();
                        Table_CourseType_List.Add(Table_CourseType);
                    }

                    List<Sys_Dictionary> list3 = (from dic in Constant.Sys_Dictionary_List
                                                  where dic.Type == Convert.ToString((int)Dictionary_Type.Leader_Course_Type)
                                                  select dic).ToList();
                    foreach (Sys_Dictionary item in list3)
                    {
                        Table_CourseType Table_CourseType = new Table_CourseType();
                        Table_CourseType.Course_Key = item.Key;
                        Table_CourseType.Course_Value = item.Value;
                        Table_CourseType.Eva_Role = 4;
                        Table_CourseType.Eva_Table_List = (from table in Constant.Eva_Table_List
                                                           where table.Eva_Role == Eva_Role
                                                           select table).ToList();
                        Table_CourseType_List.Add(Table_CourseType);
                    }
                }


                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", Table_CourseType_List);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 指标库管理



        /// <summary>
        /// 获取指标库分类
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_IndicatorType(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                int P_Type = RequestHelper.int_transfer(Request, "P_Type");
                int P_Id = RequestHelper.int_transfer(Request, "P_Id");
                List<IndicatorType> list = null;
                if (P_Type > 0)
                {
                    list = (from i in Constant.IndicatorType_List where i.P_Type == P_Type select i).ToList();
                }
                else
                {
                    list = Constant.IndicatorType_List;
                }
                //根据父ID获取指标库
                if (P_Id > 0)
                {
                    list = (from i in Constant.IndicatorType_List where i.Parent_Id == P_Id select i).ToList();
                }

                //返回所有指标库数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        //上锁
        static object obj_Edit_IndicatorType = new object();
        /// <summary>
        /// 修改指标分类
        /// </summary>
        public void Edit_IndicatorType(HttpContext context)
        {
            lock (obj_Edit_IndicatorType)
            {
                int intSuccess = (int)errNum.Success;
                try
                {
                    HttpRequest Request = context.Request;
                    //指标的ID
                    int Id = RequestHelper.int_transfer(Request, "Id");

                    //获取指定要删除的指标
                    IndicatorType IndicatorType_edit = Constant.IndicatorType_List.FirstOrDefault(i => i.Id == Id);

                    if (IndicatorType_edit != null)
                    {
                        string Name = RequestHelper.string_transfer(Request, "Name");
                        string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                        var count = Constant.Indicator_List.Count(i => i.IndicatorType_Id == Id && i.UseTimes > 0);
                        if (count == 0)
                        {
                            //克隆该指标
                            IndicatorType indic = Constant.Clone<IndicatorType>(IndicatorType_edit);
                            indic.Name = Name;
                            indic.EditUID = EditUID;

                            //数据库操作成功再改缓存
                            jsonModel = Constant.IndicatorTypeService.Update(indic);
                            if (jsonModel.errNum == intSuccess)
                            {
                                IndicatorType_edit.Name = Name;
                                IndicatorType_edit.EditUID = EditUID;
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "修改失败");
                            }
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "已组卷不可编辑");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "该指标分类不存在");
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        /// <summary>
        /// 删除指标分类
        /// </summary>
        public void Delete_Indicator_Type(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                //获取指定要删除的指标分类
                IndicatorType IndicatorType_delete = Constant.IndicatorType_List.FirstOrDefault(i => i.Id == Id);
                if (IndicatorType_delete != null)
                {

                    var count = Constant.Indicator_List.Count(i => i.IndicatorType_Id == Id);
                    var count2 = Constant.IndicatorType_List.Count(i => i.Parent_Id == Id);
                    if (count == 0 && count2 == 0)
                    {
                        //克隆该指标
                        IndicatorType indic = Constant.Clone<IndicatorType>(IndicatorType_delete);
                        indic.IsDelete = (int)IsDelete.Delete;

                        //数据库操作成功再改缓存
                        jsonModel = Constant.IndicatorTypeService.Update(indic);
                        if (jsonModel.errNum == intSuccess)
                        {
                            IndicatorType_delete.IsDelete = (int)IsDelete.Delete;
                            Constant.IndicatorType_List.Remove(IndicatorType_delete);
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "有关联的指标项无法删除");
                    }

                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "该指标分类不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        //上锁
        static object obj_Add_IndicatorType = new object();
        /// <summary>
        /// 新增指标库分类
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_IndicatorType(HttpContext context)
        {
            lock (obj_Add_IndicatorType)
            {
                int intSuccess = (int)errNum.Success;
                try
                {
                    HttpRequest Request = context.Request;

                    int Parent_Id = RequestHelper.int_transfer(Request, "Parent_Id");
                    string Name = RequestHelper.string_transfer(Request, "Name");
                    string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                    //string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                    IndicatorType IndicatorType_Add = new IndicatorType()
                    {
                        Type = 0,
                        Parent_Id = Parent_Id,
                        Name = Name,
                        CreateTime = DateTime.Now,
                        CreateUID = CreateUID,
                        EditTime = DateTime.Now,
                        //EditUID = EditUID,
                        IsEnable = (int)IsEnable.Enable,
                        IsDelete = (int)IsDelete.No_Delete,

                        EditUID = "",
                        P_Type = 0,
                    };
                    //数据库添加
                    jsonModel = new IndicatorTypeService().Add(IndicatorType_Add);

                    //从数据库返回的ID绑定
                    IndicatorType_Add.Id = RequestHelper.int_transfer(Convert.ToString(jsonModel.retData));
                    if (jsonModel.errNum == intSuccess && !Constant.IndicatorType_List.Contains(IndicatorType_Add))
                    {
                        //缓存添加
                        Constant.IndicatorType_List.Add(IndicatorType_Add);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        /// <summary>
        /// 获取指标库【指定类型】
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_Indicator(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //指定的指标库分类ID
            int IndicatorType_Id = RequestHelper.int_transfer(Request, "IndicatorType_Id");
            string Type = RequestHelper.string_transfer(Request, "Type");
            int intType = RequestHelper.int_transfer(Request, "Type");
            try
            {
                if (IndicatorType_Id > 0)
                {
                    //获取某指标库类型下的指标
                    List<Indicator> indicator_List = null;
                    if (!string.IsNullOrEmpty(Type))
                    {
                        indicator_List = (from indicator in Constant.Indicator_List where indicator.IndicatorType_Id == IndicatorType_Id && indicator.Type == intType select indicator).ToList();
                    }
                    else
                    {
                        indicator_List = (from indicator in Constant.Indicator_List where indicator.IndicatorType_Id == IndicatorType_Id select indicator).ToList();
                    }

                    //返回所有指标库数据
                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", indicator_List);
                }
                else
                {
                    //返回所有指标库数据
                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", Constant.Indicator_List);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        //上锁
        static object obj_Add_Indicator = new object();
        /// <summary>
        /// 新增指标库
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Indicator(HttpContext context)
        {
            lock (obj_Add_Indicator)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                //指标名称
                string Name = RequestHelper.string_transfer(Request, "Name");
                //指标分类编号
                int IndicatorType_Id = RequestHelper.int_transfer(Request, "IndicatorType_Id");
                int QuesType_Id = RequestHelper.int_transfer(Request, "QuesType_Id");
                string OptionA = RequestHelper.string_transfer(Request, "OptionA");
                string OptionB = RequestHelper.string_transfer(Request, "OptionB");
                string OptionC = RequestHelper.string_transfer(Request, "OptionC");
                string OptionD = RequestHelper.string_transfer(Request, "OptionD");
                string OptionE = RequestHelper.string_transfer(Request, "OptionE");
                string OptionF = RequestHelper.string_transfer(Request, "OptionF");
                int UseTimes = RequestHelper.int_transfer(Request, "UseTimes");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");

                int Type = RequestHelper.int_transfer(Request, "Type");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                try
                {
                    Indicator Indicator_Add = new Indicator()
                    {
                        Name = Name,
                        IndicatorType_Id = IndicatorType_Id,
                        QuesType_Id = QuesType_Id,
                        OptionA = OptionA,
                        OptionB = OptionB,
                        OptionC = OptionC,
                        OptionD = OptionD,
                        OptionE = OptionE,
                        OptionF = OptionF,
                        UseTimes = UseTimes,
                        Remarks = Remarks,
                        Type = Type,
                        CreateUID = CreateUID,
                        CreateTime = DateTime.Now,
                        EditUID = EditUID,
                        EditTime = DateTime.Now,
                        IsEnable = (int)IsEnable.Enable,
                        IsDelete = (int)IsDelete.No_Delete,

                    };
                    //数据库添加
                    jsonModel = new IndicatorService().Add(Indicator_Add);
                    //从数据库返回的ID绑定
                    Indicator_Add.Id = RequestHelper.int_transfer(Convert.ToString(jsonModel.retData));
                    if (jsonModel.errNum == intSuccess && !Constant.Indicator_List.Contains(Indicator_Add))
                    {
                        //缓存添加
                        Constant.Indicator_List.Add(Indicator_Add);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        //上锁
        static object obj_Edit_Indicator = new object();
        /// <summary>
        /// 修改指标
        /// </summary>
        public void Edit_Indicator(HttpContext context)
        {
            lock (obj_Edit_Indicator)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                //指标的ID
                int Id = RequestHelper.int_transfer(Request, "Id");
                int QuesType_Id = RequestHelper.int_transfer(Request, "QuesType_Id");
                int IndicatorType_Id = RequestHelper.int_transfer(Request, "IndicatorType_Id");
                string OptionA = RequestHelper.string_transfer(Request, "OptionA");
                string OptionB = RequestHelper.string_transfer(Request, "OptionB");
                string OptionC = RequestHelper.string_transfer(Request, "OptionC");
                string OptionD = RequestHelper.string_transfer(Request, "OptionD");
                string OptionE = RequestHelper.string_transfer(Request, "OptionE");
                string OptionF = RequestHelper.string_transfer(Request, "OptionF");
                int UseTimes = RequestHelper.int_transfer(Request, "UseTimes");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                int Type = RequestHelper.int_transfer(Request, "Type");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                try
                {
                    //获取指定要删除的指标
                    Indicator Indicator_edit = Constant.Indicator_List.FirstOrDefault(i => i.Id == Id);
                    if (Indicator_edit != null)
                    {
                        //指标名称
                        string Name = RequestHelper.string_transfer(Request, "Name");
                        //克隆该指标
                        Indicator indic = Constant.Clone<Indicator>(Indicator_edit);
                        indic.Name = Name;
                        indic.QuesType_Id = QuesType_Id;
                        indic.IndicatorType_Id = IndicatorType_Id;
                        indic.OptionA = OptionA;
                        indic.OptionB = OptionB;
                        indic.OptionC = OptionC;
                        indic.OptionD = OptionD;
                        indic.OptionE = OptionE;
                        indic.OptionF = OptionF;

                        indic.Remarks = Remarks;
                        indic.UseTimes = UseTimes;
                        indic.Type = Type;
                        indic.EditUID = EditUID;
                        //数据库操作成功再改缓存
                        jsonModel = Constant.IndicatorService.Update(indic);
                        if (jsonModel.errNum == intSuccess)
                        {
                            Indicator_edit.Name = Name;

                            Indicator_edit.QuesType_Id = QuesType_Id;
                            Indicator_edit.IndicatorType_Id = IndicatorType_Id;
                            Indicator_edit.OptionA = OptionA;
                            Indicator_edit.OptionB = OptionB;
                            Indicator_edit.OptionC = OptionC;
                            Indicator_edit.OptionD = OptionD;
                            Indicator_edit.OptionE = OptionE;
                            Indicator_edit.OptionF = OptionF;
                            Indicator_edit.Remarks = Remarks;
                            Indicator_edit.UseTimes = UseTimes;
                            Indicator_edit.Type = Type;
                            Indicator_edit.EditUID = EditUID;
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "修改失败");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "该指标不存在");
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        /// <summary>
        /// 删除指标
        /// </summary>
        public void Delete_Indicator(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                //获取指定要删除的指标
                Indicator Indicator_delete = Constant.Indicator_List.FirstOrDefault(i => i.Id == Id);
                if (Indicator_delete != null)
                {
                    //克隆该指标
                    Indicator indic = Constant.Clone<Indicator>(Indicator_delete);
                    indic.IsDelete = (int)IsDelete.Delete;
                    //数据库操作成功再改缓存
                    jsonModel = Constant.IndicatorService.Update(indic);
                    if (jsonModel.errNum == intSuccess)
                    {
                        Indicator_delete.IsDelete = (int)IsDelete.Delete;
                        Constant.Indicator_List.Remove(Indicator_delete);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "该指标不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion
            
        #region 获取教师信息【携带 课程-授课班】

        public void GetTeacherInfo_Course_Cls(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            string teacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            string ReguId = RequestHelper.string_transfer(Request, "ReguId");
            try
            {
                //List<T_C_Model> list = Teacher_Course_ClassInfo(ReguId);

                List<CourseRoom> list =(from room in Constant.CourseRoom_List   select room).ToList();
                if (list.Count > 0)
                {
                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", list);
                }

                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "没有数据");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        //public static List<T_C_Model> Teacher_Course_ClassInfo(string ReguId)
        //{
        //    List<T_C_Model> t_List = new List<T_C_Model>();
        //    List<T_C_Model> modelList = new List<T_C_Model>();
        //    try
        //    {
        //        var rooms = Constant.CourseRoom_List;
        //        var courses = Constant.Course_List;
        //        var clss = Constant.ClassInfo_List;

        //        t_List = (from teacher in Constant.Teacher_List
        //                  join user in Constant.UserInfo_List on teacher.UniqueNo equals user.UniqueNo
        //                  join department in Constant.Major_List on teacher.Major_ID equals department.Id
        //                  select new T_C_Model()
        //                  {
        //                      Teacher_Name = user.Name,
        //                      UniqueNo = user.UniqueNo,
        //                      Department_Name = department.Major_Name,
        //                      Department_UniqueNo = department.Id,
        //                      T_C_Model_Childs = new List<T_C_Model_Child>(),
        //                  }).ToList();

        //        List<T_C_Model_Child> list = (from room in rooms
        //                                      join cls in clss on room.ClassID equals cls.ClassNO
        //                                      join course in courses on room.Coures_Id equals course.UniqueNo
        //                                      join exp in Constant.Expert_Teacher_Course_List on new
        //                                      {
        //                                          ReguId,
        //                                          room.TeacherUID,
        //                                          UniqueNo = course.UniqueNo
        //                                      } equals new
        //                                      {
        //                                          exp.ReguId,
        //                                          exp.TeacherUID,
        //                                          UniqueNo = exp.CourseId
        //                                      } into exps
        //                                      from exp_ in exps.DefaultIfEmpty()
        //                                      select new T_C_Model_Child()
        //                                      {
        //                                          TeacherUID = room.TeacherUID,
        //                                          Course_Name = course.Name,
        //                                          Course_UniqueNo = course.UniqueNo,

        //                                          Selected = exp_ == null ? false : true,
        //                                          SelectedExperUID = exp_ == null ? "" : exp_.ExpertUID,
        //                                          SelectedExperName = exp_ == null ? "" : exp_.ExpertName,
        //                                      }).Distinct(new T_C_Model_ChildComparer()).ToList();

        //        foreach (var child in t_List)
        //        {
        //            var liis = (from s in list where s.TeacherUID == child.UniqueNo select s).ToList();
        //            if (liis.Count > 0)
        //            {
        //                child.T_C_Model_Childs = liis;
        //                modelList.Add(child);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        LogHelper.Error(ex);
        //    }

        //    return modelList;
        //}

        #endregion

    }
}