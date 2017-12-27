using FEBLL;
using FEModel;
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
        static List<string> types = new List<string>() { Convert.ToString((int)Dictionary_Type.Common_Course_Type), Convert.ToString((int)Dictionary_Type.Edu_Course_Type), Convert.ToString((int)Dictionary_Type.Leader_Course_Type) };

        #region 获取定期评价

        /// <summary>
        ///获取定期评价【课堂评价】
        /// </summary>
        public void Get_Eva_RegularS(HttpContext context)
        {

            JsonModelNum jsm = new JsonModelNum();
            HttpRequest Request = context.Request;
            int intSuccess = (int)errNum.Success;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                var regulist = (from regu in Constant.Eva_Regular_List
                                join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                join user in Constant.UserInfo_List on regu.CreateUID equals user.LoginName
                                join table in Constant.Eva_Table_List on regu.TableID equals table.Id
                                where regu.Type == Type
                                select new Regu_S()
                                {
                                    SectionId = section.Id,
                                    DisPlayName = section.DisPlayName,
                                    CreateName = user.Name,
                                    ReguName = regu.Name,
                                    CreateUID = regu.CreateUID,
                                    StartTime = regu.StartTime,
                                    EndTime = regu.EndTime,
                                    CreateTime = regu.CreateTime,
                                    State = "",
                                    StateType = 0,
                                    TableName = table.Name,
                                    Id = regu.Id,
                                    LookType = regu.LookType,
                                }).ToList();

                if (SectionId > 0)
                {
                    regulist = (from regu in regulist
                                where regu.SectionId == SectionId
                                select regu).ToList();

                }

                var query_last = (from an in regulist select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();

                ReguState regustate = ReguState.进行中;
                foreach (var li in query_last)
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
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)regulist.Count() / PageSize);
                jsm.RowCount = regulist.Count();

                jsonModel = JsonModel.get_jsonmodel(0, "success", regulist);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsm) + "}");
            }
        }

        /// <summary>
        ///获取定期评价
        /// </summary>
        public void Get_Eva_Regular(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            try
            {
                jsonModel = Get_Eva_RegularHelper(SectionId, Type);
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

        public static JsonModel Get_Eva_RegularHelper(int SectionId, int Type)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                var list = (from regu in Constant.Eva_Regular_List
                            where regu.Type == Type
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            select new ReguModel()
                            {
                                SectionId = section.Id,
                                Value = regu.Name,
                                DisPlayName = section.DisPlayName,
                                Id = regu.Id,
                                Study_IsEnable = section.IsEnable,
                                EndTime = section.EndTime,
                                ReguStartTime = regu.StartTime,
                                ReguEndTime = regu.EndTime,
                            }).ToList();
                foreach (var item in Constant.StudySection_List)
                {
                    var li = list.FirstOrDefault(i => i.SectionId == item.Id);
                    if (li == null)
                    {
                        list.Add(new ReguModel()
                        {
                            SectionId = item.Id,
                            Value = "",
                            DisPlayName = item.DisPlayName,
                            Id = (int?)0,
                            Study_IsEnable = item.IsEnable,
                            EndTime = item.EndTime,
                            ReguStartTime = item.StartTime,
                            ReguEndTime = item.EndTime,
                        });
                    }
                }
                if (SectionId > 0)
                {
                    list = (from li in list where li.SectionId == SectionId select li).ToList();
                }
                ReguState regustate = ReguState.进行中;
                foreach (var li in list)
                {

                    if (li.ReguStartTime < DateTime.Now && ((DateTime)li.ReguEndTime).AddDays(1) > DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.ReguStartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.ReguState = (int)regustate;
                }
                list = (from li in list orderby li.EndTime descending select li).ToList();
                //返回所有表格数据
                model = JsonModel.get_jsonmodel(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        ///获取单独评价
        /// </summary>
        public void Get_Eva_RegularSingle(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                Eva_Regular regu = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (regu != null)
                {
                    Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => t.Id == regu.TableID);
                    StudySection section = Constant.StudySection_List.FirstOrDefault(s => s.Id == regu.Section_Id);
                    List<Major> departments = new List<Major>();
                    List<string> departmentids = new List<string>();
                    if (regu.LookType == (int)LookType.DepartmentType && regu.DepartmentIDs != "")
                    {
                        string[] departs = Split_Hepler.str_to_stringss(regu.DepartmentIDs);
                        departments = (from d in Constant.Major_List where departs.Contains(d.Id) select d).ToList();
                        departmentids = (from d in departments select d.Id).ToList();
                    }
                    var li = new
                    {
                        regu.StartTime,
                        regu.EndTime,
                        regu.Id,
                        regu.Name,
                        regu.LookType,
                        TableName = table != null ? table.Name : "",
                        section.DisPlayName,
                        SectionID = section.Id,
                        DepartmentList = departments,
                        regu.Type,
                        regu.TableID,
                        DepartmentIdList = departmentids,
                    };
                    jsonModel = JsonModel.get_jsonmodel(0, "success", li);
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "指定的定期评价不存在");
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

        /// <summary>
        ///获取课程类型
        /// </summary>
        public void Get_Eva_RegularData(HttpContext context)
        {
            JsonModelNum jsm = new JsonModelNum();
            HttpRequest Request = context.Request;
            int intSuccess = (int)errNum.Success;
            string ReguId = RequestHelper.string_transfer(Request, "ReguId");
            string Key = RequestHelper.string_transfer(Request, "Key");
            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                var list = (from exp in Constant.Expert_Teacher_Course_List
                            join teacher in Constant.Teacher_List on exp.TeacherUID equals teacher.UniqueNo
                            join regu in Constant.Eva_Regular_List on exp.ReguId equals Convert.ToString(regu.Id)
                            where exp.ReguId == ReguId
                            select new
                            {
                                exp.Id,
                                exp.TeacherName,
                                exp.ExpertName,
                                exp.Course_Name,
                                teacher.Departent_Name,
                                ReguName = regu.Name,
                                regu.StartTime,
                                regu.EndTime,
                                State = "",
                                StateType = 0,
                                LookType = regu.LookType,
                            }).ToList();

                if (Key != "")
                {
                    list = (from li in list where li.TeacherName.Contains(Key) select li).ToList();
                }

                ReguState regustate = ReguState.进行中;
                if (list.Count > 0)
                {
                    var li = list[0];
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
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
                query_last = (from an in query_last
                              select new
                              {
                                  an.Id,
                                  an.TeacherName,
                                  an.ExpertName,
                                  an.Course_Name,
                                  an.Departent_Name,
                                  ReguName = an.ReguName,
                                  an.StartTime,
                                  an.EndTime,
                                  State = Convert.ToString(regustate),
                                  StateType = (int)regustate,
                                  LookType = an.LookType,
                              }).ToList();
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsm) + "}");
            }
        }

        #endregion

        #region 删除定期评价

        /// <summary>
        /// 删除定期评价
        /// </summary>
        public void Delete_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                jsonModel = Delete_Eva_RegularHelper(Id);
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

        public static JsonModel Delete_Eva_RegularHelper(int Id)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                //获取指定要删除的定期评价
                Eva_Regular Eva_Regular_delete = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (Eva_Regular_delete != null)
                {
                    var experlist_Count = Constant.Expert_Teacher_Course_List.Count(i => i.ReguId == Convert.ToString(Eva_Regular_delete.Id));
                    if (experlist_Count == 0)
                    {
                        //数据库操作成功再改缓存
                        model = Constant.Eva_RegularService.Delete((int)Eva_Regular_delete.Id);
                        if (model.errNum == intSuccess)
                        {
                            Eva_Regular_delete.IsDelete = (int)IsDelete.Delete;
                            Constant.Eva_Regular_List.Remove(Eva_Regular_delete);
                        }
                        else
                        {
                            model = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                        }
                    }
                    else
                    {
                        model = JsonModel.get_jsonmodel(3, "failed", "该定期评价已分配任务");
                    }
                }
                else
                {
                    model = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        #endregion

        #region 编辑定期评价

        /// <summary>
        /// 修改定期评价
        /// </summary>
        public void Edit_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //名称 开始时间 结束时间  最大百分比 最小百分比
            string Name = RequestHelper.string_transfer(Request, "Name");
            int Id = RequestHelper.int_transfer(Request, "Id");
            DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
            DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
            byte LookType = Convert.ToByte(Request["LookType"]);
            DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
            DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
            string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
            string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
            string Remarks = RequestHelper.string_transfer(Request, "Remarks");
            string EditUID = RequestHelper.string_transfer(Request, "EditUID");
            int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
            int Type = RequestHelper.int_transfer(Request, "Type");
            int TableID = RequestHelper.int_transfer(Request, "TableID");
            string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");
            bool hasAcross = false;
            try
            {
                #region 查看是否交叉

                var reguList = (from regu in Constant.Eva_Regular_List where regu.Id != Id && regu.Type == Type select regu).ToList();

                foreach (Eva_Regular regu in reguList)
                {
                    if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                }

                #endregion

                if (!hasAcross)
                {
                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime > section.StartTime && EndTime < section.EndTime)
                        {
                            #region 编辑评价

                            var reguEdit = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                            if (reguEdit != null)
                            {
                                var regu_Clone = Constant.Clone<Eva_Regular>(reguEdit);

                                regu_Clone.Name = Name;
                                regu_Clone.StartTime = StartTime;
                                regu_Clone.EndTime = EndTime;
                                regu_Clone.LookType = LookType;
                                regu_Clone.Look_StartTime = Look_StartTime;
                                regu_Clone.Look_EndTime = Look_EndTime;
                                regu_Clone.MaxPercent = MaxPercent;
                                regu_Clone.MinPercent = MinPercent;
                                regu_Clone.Remarks = Remarks;
                                regu_Clone.EditTime = DateTime.Now;
                                regu_Clone.EditUID = EditUID;
                                regu_Clone.Type = Type;
                                regu_Clone.TableID = TableID;
                                regu_Clone.DepartmentIDs = DepartmentIDs;

                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Update(regu_Clone);
                                if (jsonModel.errNum == 0)
                                {
                                    reguEdit.Name = Name;
                                    reguEdit.StartTime = StartTime;
                                    reguEdit.EndTime = EndTime;
                                    reguEdit.LookType = LookType;
                                    reguEdit.Look_StartTime = Look_StartTime;
                                    reguEdit.Look_EndTime = Look_EndTime;
                                    reguEdit.MaxPercent = MaxPercent;
                                    reguEdit.MinPercent = MinPercent;
                                    reguEdit.Remarks = Remarks;
                                    reguEdit.EditTime = DateTime.Now;
                                    reguEdit.EditUID = EditUID;
                                    reguEdit.Type = Type;
                                    reguEdit.TableID = TableID;
                                    reguEdit.DepartmentIDs = DepartmentIDs;
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "编辑失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
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

        #region 添加定期评价

        //上锁
        static object obj_Add_Eva_Regular = new object();
        /// <summary>
        /// 新增定期评价
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_Regular(HttpContext context)
        {
            lock (obj_Add_Eva_Regular)
            {
                HttpRequest Request = context.Request;
                //名称 开始时间 结束时间  最大百分比 最小百分比
                string Name = RequestHelper.string_transfer(Request, "Name");
                DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
                DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
                byte LookType = Convert.ToByte(Request["LookType"]);
                DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
                DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
                string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
                string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
                int Type = RequestHelper.int_transfer(Request, "Type");
                int TableID = RequestHelper.int_transfer(Request, "TableID");

                string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");
                bool hasAcross = false;
                try
                {
                    #region 查看是否交叉

                    var reguList = (from regu in Constant.Eva_Regular_List where regu.Type == Type select regu).ToList();

                    foreach (Eva_Regular regu in reguList)
                    {
                        if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                    }

                    #endregion

                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime > section.StartTime && EndTime < section.EndTime)
                        {
                            #region 添加评价

                            if (!hasAcross)
                            {
                                //新建定期评价
                                Eva_Regular Eva_Regular_Add = new Eva_Regular()
                                {
                                    Name = Name,
                                    Section_Id = Section_Id,
                                    StartTime = StartTime,
                                    EndTime = EndTime,
                                    LookType = LookType,
                                    Look_StartTime = Look_StartTime,
                                    Look_EndTime = Look_EndTime,
                                    MaxPercent = MaxPercent,
                                    MinPercent = MinPercent,
                                    Remarks = Remarks,
                                    CreateTime = DateTime.Now,
                                    CreateUID = CreateUID,
                                    EditTime = DateTime.Now,
                                    EditUID = EditUID,
                                    IsEnable = (int)IsEnable.Enable,
                                    IsDelete = (int)IsDelete.No_Delete,
                                    Type = Type,
                                    TableID = TableID,
                                    DepartmentIDs = DepartmentIDs,

                                };
                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Add(Eva_Regular_Add);
                                if (jsonModel.errNum == 0)
                                {
                                    //从数据库返回的ID绑定
                                    Eva_Regular_Add.Id = Convert.ToInt32(jsonModel.retData);
                                    //缓存添加
                                    Constant.Eva_Regular_List.Add(Eva_Regular_Add);
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
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


        #endregion

        #region 定期评价管理






        /// <summary>
        /// 获取评价名称
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_Regular_Name(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;

                var _list = (from t in Constant.Eva_Regular_List
                             where t.StartTime < DateTime.Now
                             select new { Name = t.Name }).Distinct();
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", _list);
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

        //上锁int score
        static object obj_Add_Eva_QuestionAnswer = new object();
        /// <summary>
        /// 新增学生答题
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_QuestionAnswer(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {
                HttpRequest Request = context.Request;
                //分配表的ID
                int Eva_Distribution_Id = RequestHelper.int_transfer(Request, "Eva_Distribution_Id");
                //学生【用户唯一标识符】
                string StudentUID = RequestHelper.string_transfer(Request, "StudentUID");
                //课程的ID
                string CourseId = RequestHelper.string_transfer(Request, "CourseId");
                //教师的ID
                string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
                //学年学期的ID
                int SectionId = RequestHelper.int_transfer(Request, "SectionId");
                //得分
                decimal Score = RequestHelper.decimal_transfer(Request, "Score");
                //创建者
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                int intSuccess = (int)errNum.Success;
                //课程分类
                string CourseTypeId = Constant.CourseRel_List.FirstOrDefault(i => i.Course_Id == CourseId).CourseType_Id;
                int Type = RequestHelper.int_transfer(Request, "Type");
                try
                {

                    //学生回答任务信息表
                    Eva_QuestionAnswer Eva_QuestionAnswer = new Eva_QuestionAnswer()
                    {
                        Eva_Distribution_Id = Eva_Distribution_Id,
                        StudentUID = StudentUID,
                        CourseTypeId = CourseTypeId,
                        CourseId = CourseId,
                        TeacherUID = TeacherUID,
                        SectionId = SectionId,
                        Score = Score,
                        CreateUID = CreateUID,
                        CreateTime = DateTime.Now,
                        EditTime = DateTime.Now,
                        EditUID = CreateUID,
                        IsDelete = (int)IsDelete.No_Delete,
                        IsEnable = (int)IsEnable.Enable
                    };

                    //表单明细
                    string List = RequestHelper.string_transfer(Request, "List");
                    //序列化表单详情列表
                    List<Eva_QuestionAnswer_Detail> Eva_QuestionAnswer_Detail_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Detail>>(List);

                    jsonModel = Constant.Eva_QuestionAnswerService.Add(Eva_QuestionAnswer);

                    Eva_QuestionAnswer.Id = Convert.ToInt32(jsonModel.retData);
                    if (jsonModel.errNum == intSuccess && !Constant.Eva_QuestionAnswer_List.Contains(Eva_QuestionAnswer))
                    {
                        Constant.Eva_QuestionAnswer_List.Add(Eva_QuestionAnswer);

                        //答题任务详情填充
                        foreach (Eva_QuestionAnswer_Detail item in Eva_QuestionAnswer_Detail_List)
                        {
                            item.Eva_TaskAnswer_Id = Eva_QuestionAnswer.Id;
                            item.CreateTime = DateTime.Now;
                            item.CreateUID = StudentUID;
                            item.EditUID = StudentUID;
                            item.EditTime = DateTime.Now;
                            item.IsDelete = (int)IsDelete.No_Delete;
                            item.IsEnable = (int)IsEnable.Enable;
                            //数据库插入
                            JsonModel jsm = Constant.Eva_QuestionAnswer_DetailService.Add(item);
                            //插入成功入缓存
                            if (jsm.errNum == intSuccess)
                            {
                                item.Id = Convert.ToInt32(jsm.retData);
                                if (!Constant.Eva_QuestionAnswer_Detail_List.Contains(item))
                                {
                                    Constant.Eva_QuestionAnswer_Detail_List.Add(item);
                                }
                            }
                        }
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

    }
}