using FEBLL;
using FEModel;
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
        #region 添加教师课程【专家】

        //上锁
        static object obj_AddExpert_List_Teacher_Course = new object();
        public void AddExpert_List_Teacher_Course(HttpContext context)
        {
            lock (obj_AddExpert_List_Teacher_Course)
            {

                HttpRequest Request = context.Request;
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string ExpertUID = RequestHelper.string_transfer(Request, "ExpertUID");
                int Type = RequestHelper.int_transfer(Request, "Type");
                string Regu_Id = RequestHelper.string_transfer(Request, "Regu_Id");
                int SectionID = RequestHelper.int_transfer(Request, "SectionID");

                //表单明细
                string List = RequestHelper.string_transfer(Request, "List");
                try
                {
                    //序列化表单详情列表
                    List<Expert_Teacher_Course> Expert_Teacher_Course_List = JsonConvert.DeserializeObject<List<Expert_Teacher_Course>>(List);

                    foreach (var item in Expert_Teacher_Course_List)
                    {
                        item.SecionID = SectionID;
                        item.ReguId = Regu_Id;
                        item.EditTime = DateTime.Now;
                        item.CreateTime = DateTime.Now;
                        item.EditUID = item.CreateUID;
                        item.IsEnable = (int)IsEnable.Enable;
                        item.IsDelete = (int)IsDelete.No_Delete;
                    }
                    jsonModel = AddExpert_List_Teacher_CourseHelper(Expert_Teacher_Course_List, SectionID, Regu_Id, ExpertUID);
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

        public static JsonModel AddExpert_List_Teacher_CourseHelper(List<Expert_Teacher_Course> Expert_Teacher_Course_List, int SectionID, string Regu_Id, string ExpertUID)
        {
            JsonModel model = new JsonModel();
            int Success = (int)errNum.Success;
            try
            {


                List<Expert_Teacher_Course> Expert_Teacher_Course_List_Copy = new List<Expert_Teacher_Course>();
                List<Expert_Teacher_Course> data_r_Copy = new List<Expert_Teacher_Course>();
                //指定某个学年学期定期评价某专家的数据
                List<Expert_Teacher_Course> data_r = (from s in Constant.Expert_Teacher_Course_List
                                                      where s.ReguId == Regu_Id && s.ExpertUID == ExpertUID && s.SecionID == SectionID
                                                      select s).ToList();

                Expert_Teacher_Course_List.ForEach(i => Expert_Teacher_Course_List_Copy.Add(i));
                data_r.ForEach(i => data_r_Copy.Add(i));

                //找到相同的，剩余的就是需要去库里删除的
                var list_remove = data_r_Copy.Where(child => Expert_Teacher_Course_List_Copy.Count(item => item.TeacherUID == child.TeacherUID && item.CourseId == child.CourseId && Regu_Id == child.ReguId) > 0).ToList();
                for (int i = list_remove.Count - 1; i > -1; i--)
                {
                    if (data_r.Contains(list_remove[i]))
                    {
                        //已经存勿添加了
                        data_r.Remove(list_remove[i]);
                    }
                }
                //找出库里面已经有的
                var list_exits = Expert_Teacher_Course_List_Copy.Where(item => data_r_Copy.Count(child => child.TeacherUID == item.TeacherUID && item.CourseId == child.CourseId && child.ReguId == Regu_Id) > 0).ToList();
                for (int i = list_exits.Count - 1; i > -1; i--)
                {
                    if (Expert_Teacher_Course_List.Contains(list_exits[i]))
                    {
                        //已经存勿添加了
                        Expert_Teacher_Course_List.Remove(list_exits[i]);
                    }
                }
                foreach (Expert_Teacher_Course item in data_r)
                {
                    JsonModel mo = Constant.Expert_Teacher_CourseService.Delete((int)item.Id);
                    if (mo.errNum == Success)
                    {
                        Constant.Expert_Teacher_Course_List.Remove(item);
                    }
                }

                //
                foreach (Expert_Teacher_Course item in Expert_Teacher_Course_List)
                {
                    model = Constant.Expert_Teacher_CourseService.Add(item);
                    if (model.errNum == Success)
                    {
                        //添加
                        Constant.Expert_Teacher_Course_List.Add(item);
                        item.Id = Convert.ToInt32(model.retData);
                    }
                }
                model = JsonModel.get_jsonmodel(Success, "success", 0);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        #endregion

        #region 课堂信息-班级

        public static List<ClassInfo> Course_ClassInfo_ByTeacher(string TeacherUID)
        {
            List<ClassInfo> student_classInfo = null;
            try
            {
                student_classInfo = (from c in Constant.CourseRoom_List
                                     where c.TeacherUID == TeacherUID
                                     join s in Constant.ClassInfo_List on c.ClassID equals s.ClassNO
                                     orderby s.Id
                                     select s).Distinct().ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return student_classInfo;
        }

        #endregion

        #region 删除教师课程

        public void DeleteExpert_List_Teacher_Course(HttpContext context)
        {
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                var exp = Constant.Expert_Teacher_Course_List.FirstOrDefault(i => i.Id == Id);
                if (exp != null)
                {
                    jsonModel = Constant.Expert_Teacher_CourseService.Delete((int)exp.Id);
                    if (jsonModel.errNum == 0)
                    {
                        Constant.Expert_Teacher_Course_List.Remove(exp);
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



        #endregion

        #region 课程类型-表管理

        public void GetCourseType_Table(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string CourseTypeId = RequestHelper.string_transfer(Request, "CourseTypeId");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");

            try
            {
                var data = (from s in Constant.Sys_Dictionary_List
                            where s.Key == CourseTypeId && s.Type == "0" && s.SectionId == SectionId
                            join tb in Constant.Eva_CourseType_Table_List on s.Key equals tb.CourseTypeId
                            where tb.StudySection_Id == SectionId
                            join b in Constant.Eva_Table_List on tb.TableId equals b.Id
                            where b.IsEnable == (int)IsEnable.Enable
                            join user in Constant.UserInfo_List on b.CreateUID equals user.UniqueNo into users_
                            from u in users_.DefaultIfEmpty()
                            select new { tb.Id, b.Name, b.IsScore, b.UseTimes, b.CreateUID, b.CreateTime, b.IsEnable, UserName = u != null ? u.Name : "", TableId = b.Id, CourseTypeId = s.Key }).ToList();
                jsonModel = JsonModel.get_jsonmodel(0, "success", data);
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

        public void AddCourseType_Table(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string CourseTypeId = RequestHelper.string_transfer(Request, "CourseTypeId");
            //表格列表
            string TableList = RequestHelper.string_transfer(Request, "TableList");
            string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            try
            {
                //序列化表单详情列表
                List<int> Table_A_List = JsonConvert.DeserializeObject<List<int>>(TableList);
                jsonModel = AddCourseType_TableHelper(CourseTypeId, CreateUID, Table_A_List, SectionId);
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

        public JsonModel AddCourseType_TableHelper(string CourseTypeId, string CreateUID, List<int> tableList, int SectionId)
        {
            int intSuccess = (int)errNum.Success;
            JsonModel jsmodel = new JsonModel();
            try
            {
                jsmodel = JsonModel.get_jsonmodel(intSuccess, "success", 0);

                var tablss_add = (from vir_t in tableList
                                  join tab_c in Constant.Eva_CourseType_Table_List on new
                                  {
                                      TableId = vir_t,
                                      CourseTypeId = CourseTypeId
                                  } equals new
                                  {
                                      TableId = (int)tab_c.TableId,
                                      CourseTypeId = tab_c.CourseTypeId
                                  } into tabc_cs
                                  from tac_ in tabc_cs.DefaultIfEmpty()
                                  where tac_ == null
                                  select new { tac_, vir_t }).ToList();

                var tablss_delete = (from tab_c in Constant.Eva_CourseType_Table_List
                                     where tab_c.CourseTypeId == CourseTypeId && tab_c.StudySection_Id == SectionId
                                     join t in Constant.Eva_Table_List on tab_c.TableId equals t.Id
                                     where t.IsEnable == (int)IsEnable.Enable
                                     join vir_t in tableList on t.Id equals vir_t into vir_ts
                                     from vir_t_ in vir_ts.DefaultIfEmpty()
                                     where vir_t_ == 0
                                     select new { tab_c, vir_t_ }).ToList();

                foreach (var item in tablss_add)
                {
                    Eva_CourseType_Table ect = new Eva_CourseType_Table()
                    {
                        CourseTypeId = CourseTypeId,
                        CreateTime = DateTime.Now,
                        CreateUID = CreateUID,
                        IsDelete = (int)IsDelete.No_Delete,
                        TableId = item.vir_t,
                        StudySection_Id = SectionId,
                    };
                    var jsmo = Constant.Eva_CourseType_TableService.Add(ect);
                    if (jsmo.errNum == 0)
                    {
                        Constant.Eva_CourseType_Table_List.Add(ect);
                        ect.Id = Convert.ToInt32(jsmo.retData);
                        TableUsingAdd(ect.TableId);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "内部错误");
                        break;
                    }
                }

                foreach (var item in tablss_delete)
                {
                    Eva_CourseType_Table eva_CourseType_Table_clone = Constant.Clone<Eva_CourseType_Table>(item.tab_c);
                    eva_CourseType_Table_clone.IsDelete = (int)IsDelete.Delete;
                    var jsm = Constant.Eva_CourseType_TableService.Update(eva_CourseType_Table_clone);
                    if (jsm.errNum == 0)
                    {
                        Constant.Eva_CourseType_Table_List.Remove(item.tab_c);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "内部错误");
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                jsonModel = JsonModel.get_jsonmodel(3, "failed", ex.Message);
                LogHelper.Error(ex);
            }
            return jsmodel;
        }


        public void DeleteCourseType_Table(HttpContext context)
        {
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                jsonModel = DeleteCourseType_TableHelper(Id);
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

        public JsonModel DeleteCourseType_TableHelper(int Id)
        {
            int intSuccess = (int)errNum.Success;
            JsonModel jsmodel = new JsonModel();
            try
            {
                Eva_CourseType_Table delete_Eva_CourseType_Table = Constant.Eva_CourseType_Table_List.FirstOrDefault(i => i.Id == Id);

                if (delete_Eva_CourseType_Table != null)
                {
                    Eva_CourseType_Table delete_Eva_CourseType_Table_clone = Constant.Clone<Eva_CourseType_Table>(delete_Eva_CourseType_Table);
                    delete_Eva_CourseType_Table_clone.IsDelete = (int)IsDelete.Delete;
                    var jsmo = Constant.Eva_CourseType_TableService.Update(delete_Eva_CourseType_Table_clone);
                    if (jsmo.errNum == 0)
                    {
                        Constant.Eva_CourseType_Table_List.Remove(delete_Eva_CourseType_Table);
                        jsmodel = JsonModel.get_jsonmodel(intSuccess, "success", 0);

                        TableUsingReduce(delete_Eva_CourseType_Table_clone.TableId);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "该项分配不存在");
                    }
                }
            }
            catch (Exception ex)
            {
                jsonModel = JsonModel.get_jsonmodel(3, "failed", ex.Message);
                LogHelper.Error(ex);
            }
            return jsmodel;
        }

        #endregion

        #region 班级获取

        /// <summary>
        /// 获取当前教师的班级
        /// </summary>
        public void Get_Teacher_Class(HttpContext context)
        {
            HttpRequest Request = context.Request;
            int intSuccess = (int)errNum.Success;
            string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            try
            {
                //获取当前教师的班级               
                List<ClassInfo> list = Course_ClassInfo_ByTeacher(TeacherUID);
                if (list.Count() > 0)
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

        #endregion
    }
}