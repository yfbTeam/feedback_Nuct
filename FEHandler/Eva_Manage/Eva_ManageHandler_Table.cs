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

        #region 获取表

        /// <summary>
        /// 获取表格
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_Eva_Table_S(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int Type = RequestHelper.int_transfer(Request, "Type");
            TableType TableType = (TableType)Type;
            string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
            try
            {
                List<Eva_Table> tblist = (from t in Constant.Eva_Table_List where t.Type == Type select t).ToList();
                if (TableType == FEModel.Enum.TableType.teacherself)
                {
                    tblist = (from t in Constant.Eva_Table_List where t.CreateUID == CreateUID select t).ToList();
                }
                var table_submiter = (from t in tblist
                                      join u in Constant.UserInfo_List on t.CreateUID equals u.UniqueNo
                                      select new
                                      {
                                          t,
                                          u,
                                      }).ToList();
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", table_submiter);
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
        /// 获取表格
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_Eva_Table(HttpContext context)
        {

            HttpRequest Request = context.Request;

            string CourseID = RequestHelper.string_transfer(Request, "CourseID");
            int SectionID = RequestHelper.int_transfer(Request, "SectionID");

            int Type = RequestHelper.int_transfer(Request, "Type");        
            string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");

            try
            {
                jsonModel = Get_Eva_TableHelper(SectionID, CourseID,Type,CreateUID);
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

        public static JsonModel Get_Eva_TableHelper(int SectionID, string CourseID,int Type  ,string CreateUID)
        {
            int intSuccess = (int)errNum.Success;
            JsonModel jsmodel = new JsonModel();
            try
            {
               
                TableType TableType = (TableType)Type;
                List<Eva_Table> tblist = (from t in Constant.Eva_Table_List where t.Type == Type && t.IsEnable == (int)IsEnable.Enable select t).ToList();
                if (TableType == FEModel.Enum.TableType.teacherself)
                {
                    tblist = (from t in tblist where t.CreateUID == CreateUID select t).ToList();
                }
                if (SectionID > 0)
                {
                    tblist = (from dic in Constant.Sys_Dictionary_List
                                 where dic.Type == "0" && dic.SectionId == SectionID
                                 join cr in Constant.CourseRel_List on dic.Key equals cr.CourseType_Id
                                 where (CourseID != "" && cr.Course_Id == CourseID) || CourseID == ""
                                 join cb in Constant.Eva_CourseType_Table_List on dic.Key equals cb.CourseTypeId
                                 join tb in tblist on cb.TableId equals tb.Id                               
                                 select tb).Distinct(new Eva_TableComparer()).ToList();

                }

                //返回所有表格数据
                jsmodel = JsonModel.get_jsonmodel(intSuccess, "success", tblist);
            }
            catch (Exception ex)
            {
                jsmodel = JsonModel.get_jsonmodel(3, "failed", ex.Message);
                LogHelper.Error(ex);
            }
            return jsmodel;
        }

        #endregion

        #region 获取表详情

        /// <summary>
        /// 获取表格头部规则
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Get_Eva_Table_Header_Custom_List(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            try
            {
                var list = (from c in Constant.Eva_Table_Header_Custom_List orderby c.Sort select new { Code = c.Code, id = c.Code, name = c.Header, description = c.Header_Value }).ToList();
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
        /// 获取设计表详情【学生答题的初始化答卷】
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_TableDetail(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //表格ID
            int table_Id = RequestHelper.int_transfer(Request, "table_Id");

            int RoomID = RequestHelper.int_transfer(Request, "RoomID");
            int ReguID = RequestHelper.int_transfer(Request, "ReguID");


            string UserID = RequestHelper.string_transfer(Request, "UserID");
            //没有教学反馈
            bool no_eduType = RequestHelper.bool_transfer(Request, "no_eduType");
            Table_View table_view = new Table_View();
            try
            {
                //首先指定试卷
                var table = Constant.Eva_Table_List.FirstOrDefault(i => i.Id == table_Id);
                if (table != null)
                {
                    table_view.Table_Id = (int)table.Id;
                    table_view.IsEnable = (int)table.IsEnable;
                    table_view.Name = table.Name;
                    table_view.IsScore = (int)table.IsScore;
                    //搜集试卷题
                    List<Eva_TableDetail_S> details = (from det in Constant.Eva_TableDetail_List
                                                       where det.Eva_table_Id == table_Id
                                                       orderby det.Id
                                                       select new Eva_TableDetail_S()
                                                       {
                                                           Id = det.Id,
                                                           Indicator_Id = det.Indicator_Id,
                                                           IndicatorType_Id = det.IndicatorType_Id,
                                                           Eva_table_Id = det.Eva_table_Id,
                                                           IndicatorType_Name = det.IndicatorType_Name,
                                                           Name = det.Name,
                                                           OptionA = det.OptionA,
                                                           OptionA_S = det.OptionA_S,
                                                           OptionB = det.OptionB,
                                                           OptionB_S = det.OptionB_S,
                                                           OptionC = det.OptionC,
                                                           OptionC_S = det.OptionC_S,
                                                           OptionD = det.OptionD,
                                                           OptionD_S = det.OptionD_S,
                                                           OptionE = det.OptionE,
                                                           OptionE_S = det.OptionE_S,
                                                           OptionF = det.OptionF,
                                                           OptionF_S = det.OptionF_S,
                                                           QuesType_Id = det.QuesType_Id,
                                                           RootID = det.RootID,
                                                           Root = det.Root,
                                                           Sort = det.Sort,
                                                           Type = det.Type,
                                                           OptionF_S_Max = det.OptionF_S_Max,
                                                       }).ToList();

                    if (RoomID > 0)
                    {
                        var model = (from r in Constant.CourseRoom_List
                                     where r.Id == RoomID
                                     join section in Constant.StudySection_List on r.StudySection_Id equals section.Id
                                     join regu in Constant.Eva_Regular_List on ReguID equals regu.Id
                                     select new { r, section, regu }).ToList();

                        if (model.Count > 0)
                        {
                            var room = model[0].r;
                            var section = model[0].section;
                            var regu = model[0].regu;
                            table_view.Info = new
                            {
                                SectionID = room.StudySection_Id,
                                DisplayName = section.DisPlayName,
                                ReguID = regu.Id,
                                ReguName = regu.Name,
                                CourseID = room.Coures_Id,
                                CourseName = room.CouresName,
                                TeacherUID = room.TeacherUID,
                                TeacherName = room.TeacherName,
                                DepartmentName = room.DepartmentName,
                                RoomID = RoomID,
                                IsInClass = Constant.Class_StudentInfo_List.Count(i => i.UniqueNo == UserID && i.Class_Id == room.ClassID) > 0 ? true : false,
                            };
                        }
                    }
                    //表详情
                    table_view.Table_Detail_Dic_List = (from ps in details
                                                        group ps by ps.RootID
                                                            into g
                                                            select new Table_Detail_Dic { Root = g.FirstOrDefault(i => i.RootID == g.Key).Root, Eva_TableDetail_List = g.ToList() }).ToList();

                    //表头
                    table_view.Table_Header_List = (from header in Constant.Eva_Table_Header_List
                                                    where header.Table_Id == table.Id
                                                    orderby header.Sort
                                                    select new
                                                        Table_Header { Header = header.Name_Key, CustomCode = header.Custom_Code, Value = header.Name_Value, Type = (int)header.Type, Id = (int)header.Id }).ToList();
                }

                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", table_view);
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

        #region 添加

        //上锁
        static object obj_Add_Eva_Table = new object();
        /// <summary>
        /// 新增表格
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_Table(HttpContext context)
        {
            lock (obj_Add_Eva_Table)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                string Name = RequestHelper.string_transfer(Request, "Name");
                int IsScore = RequestHelper.int_transfer(Request, "IsScore");
                int IsEnable = RequestHelper.int_transfer(Request, "IsEnable");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                string CourseType_Id = RequestHelper.string_transfer(Request, "CourseType_Id");
                int Type = RequestHelper.int_transfer(Request, "Type");
                try
                {
                    Eva_Table Eva_Table_Add = new Eva_Table()
                    {
                        Name = Name,
                        IsScore = (byte)IsScore,
                        CousrseType_Id = CourseType_Id,
                        Type = Type,
                        //Type = 2,//新加的  主要区别于即时(1)和扫码(0)
                        Remarks = Remarks,
                        UseTimes = 0,
                        CreateTime = DateTime.Now,
                        CreateUID = CreateUID,
                        EditTime = DateTime.Now,
                        EditUID = EditUID,
                        IsEnable = (byte)IsEnable,
                        IsDelete = (int)IsDelete.No_Delete
                    };

                    //表单明细
                    string List = RequestHelper.string_transfer(Request, "List");
                    //序列化表单详情列表
                    List<Table_A> Table_A_List = JsonConvert.DeserializeObject<List<Table_A>>(List);

                    //数据库添加
                    jsonModel = Constant.Eva_TableService.Add(Eva_Table_Add);
                    if (jsonModel.errNum == 0)
                    {
                        //从数据库返回的ID绑定
                        Eva_Table_Add.Id = RequestHelper.int_transfer(Convert.ToString(jsonModel.retData));
                        string head_value = RequestHelper.string_transfer(Request, "head_value");
                        string lisss = RequestHelper.string_transfer(Request, "lisss");
                        //添加头部内容
                        Table_Header((int)Eva_Table_Add.Id, head_value, lisss);
                        if (jsonModel.errNum == intSuccess)
                        {
                            //缓存添加
                            Constant.Eva_Table_List.Add(Eva_Table_Add);
                            //解析正常才可进行操作
                            if (Table_A_List != null)
                            {
                                //表格详情表创建添加
                                Eva_TableAdd_Helper(CreateUID, EditUID, Eva_Table_Add, Table_A_List);
                            }
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
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

        #region 拷贝

        static object obj_Copy_Eva_Table = new object();
        /// <summary>
        /// 复制表格
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Copy_Eva_Table(HttpContext context)
        {
            lock (obj_Copy_Eva_Table)
            {
                HttpRequest Request = context.Request;
                int table_Id = RequestHelper.int_transfer(Request, "table_Id");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                try
                {
                    Eva_Table Eva_Table_Need_Copy = Constant.Eva_Table_List.FirstOrDefault(t => t.Id == table_Id);
                    if (Eva_Table_Need_Copy != null)
                    {
                        Eva_Table Eva_Table_Copy_Clone = Constant.Clone<Eva_Table>(Eva_Table_Need_Copy);
                        Eva_Table_Copy_Clone.Id = null;
                        Eva_Table_Copy_Clone.UseTimes = 0;
                        Eva_Table_Copy_Clone.CreateUID = CreateUID;
                        Eva_Table_Copy_Clone.EditUID = CreateUID;
                        Eva_Table_Copy_Clone.CreateTime = DateTime.Now;
                        Eva_Table_Copy_Clone.EditTime = DateTime.Now;
                        jsonModel = Constant.Eva_TableService.Add(Eva_Table_Copy_Clone);
                        if (jsonModel.errNum == 0)
                        {
                            Eva_Table_Copy_Clone.Id = Convert.ToInt32(jsonModel.retData);

                            //添加克隆出来的表
                            Constant.Eva_Table_List.Add(Eva_Table_Copy_Clone);

                            //表头复制
                            var table_headers = (from t_h in Constant.Eva_Table_Header_List where t_h.Table_Id == table_Id select t_h).ToList();
                            foreach (var header in table_headers)
                            {
                                Eva_Table_Header h_Clone = Constant.Clone<Eva_Table_Header>(header);
                                h_Clone.Table_Id = Eva_Table_Copy_Clone.Id;
                                h_Clone.Id = null;
                                var jsonmodel = Constant.Eva_Table_HeaderService.Add(h_Clone);
                                if (jsonmodel.errNum == 0)
                                {
                                    h_Clone.Id = Convert.ToInt32(jsonmodel.retData);
                                    Constant.Eva_Table_Header_List.Add(h_Clone);
                                }
                            }

                            //详情题干添加
                            var table_details = (from detail in Constant.Eva_TableDetail_List where detail.Eva_table_Id == table_Id select detail).ToList();
                            foreach (var detail in table_details)
                            {
                                Eva_TableDetail detail_clone = Constant.Clone<Eva_TableDetail>(detail);
                                detail_clone.Eva_table_Id = Eva_Table_Copy_Clone.Id;
                                detail_clone.Id = null;
                                var jsonmodel = Constant.Eva_TableDetailService.Add(detail_clone);
                                if (jsonmodel.errNum == 0)
                                {
                                    detail_clone.Id = Convert.ToInt32(jsonmodel.retData);
                                    Constant.Eva_TableDetail_List.Add(detail_clone);

                                    Indicate_Using_Add((int)detail_clone.Indicator_Id);
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

        #region 编辑

        //上锁
        static object obj_Edit_Eva_Table = new object();
        /// <summary>
        /// 编辑表格
        /// </summary>
        public void Edit_Eva_Table(HttpContext context)
        {
            lock (obj_Edit_Eva_Table)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                //表格Id
                int table_Id = RequestHelper.int_transfer(Request, "table_Id");
                try
                {
                    //获取指定要删除的表格
                    Eva_Table Eva_Table_edit = Constant.Eva_Table_List.FirstOrDefault(i => i.Id == table_Id);
                    if (Eva_Table_edit != null)
                    {
                        string Name = RequestHelper.string_transfer(Request, "Name");

                        int IsScore = RequestHelper.int_transfer(Request, "IsScore");
                        string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                        string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                        string CourseType_Id = RequestHelper.string_transfer(Request, "CourseType_Id");

                        int IsEnable = RequestHelper.int_transfer(Request, "IsEnable");
                        //克隆该表格
                        Eva_Table Eva_Table_clone = Constant.Clone<Eva_Table>(Eva_Table_edit);
                        Eva_Table_clone.Name = Name;
                        Eva_Table_clone.IsScore = (byte)IsScore;
                        Eva_Table_clone.Remarks = Remarks;
                        Eva_Table_clone.EditTime = DateTime.Now;
                        Eva_Table_clone.EditUID = EditUID;
                        Eva_Table_clone.IsEnable = (byte)IsEnable;
                        //数据库操作成功再改缓存
                        jsonModel = Constant.Eva_TableService.Update(Eva_Table_clone);
                        if (jsonModel.errNum == intSuccess)
                        {
                            Eva_Table_edit.Name = Name;
                            Eva_Table_edit.IsScore = (byte)IsScore;
                            Eva_Table_edit.Remarks = Remarks;
                            Eva_Table_edit.EditTime = DateTime.Now;
                            Eva_Table_edit.EditUID = EditUID;
                            Eva_Table_edit.IsEnable = (byte)IsEnable;
                            //表单明细
                            string List = RequestHelper.string_transfer(Request, "List");

                            //序列化表单详情列表
                            List<Table_A> Table_A_List = JsonConvert.DeserializeObject<List<Table_A>>(List);
                            //先进行删除，然后进行添加
                            List<Eva_TableDetail> table_list = (from t in Constant.Eva_TableDetail_List where t.Eva_table_Id == Eva_Table_edit.Id select t).ToList();

                            //删除详情表
                            foreach (Eva_TableDetail item in table_list)
                            {
                                JsonModel m = Constant.Eva_TableDetailService.Delete((int)item.Id);
                                if (m.errNum == intSuccess)
                                {
                                    Constant.Eva_TableDetail_List.Remove(item);
                                    Indicate_Using_Reduce((int)item.Indicator_Id);
                                }
                            }
                            Remove_Header((int)Eva_Table_edit.Id);

                            //解析正常才可进行操作
                            if (Table_A_List != null)
                            {
                                //表格详情表创建添加
                                Eva_TableAdd_Helper(Eva_Table_edit.EditUID, EditUID, Eva_Table_edit, Table_A_List);

                                string head_value = RequestHelper.string_transfer(Request, "head_value");
                                string lisss = RequestHelper.string_transfer(Request, "lisss");
                                //表头信息添加
                                Table_Header((int)Eva_Table_edit.Id, head_value, lisss);
                            }
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "编辑失败");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "该表格不存在");
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
        /// 移除头部内容
        /// </summary>
        /// <param name="table_Id"></param>
        /// <param name="Request"></param>
        public static void Remove_Header(int table_Id)
        {
            try
            {
                List<Eva_Table_Header> headers = (from h in Constant.Eva_Table_Header_List where h.Table_Id == table_Id select h).ToList();
                foreach (var item in headers)
                {
                    var model = Constant.Eva_Table_HeaderService.Delete((int)item.Id);
                    if (model.errNum == 0)
                    {
                        Constant.Eva_Table_Header_List.Remove(item);
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region 删除

        /// <summary>
        /// 删除表格
        /// </summary>
        public void Delete_Eva_Table(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {

                //获取指定要删除的表格
                Eva_Table Eva_Table_delete = Constant.Eva_Table_List.FirstOrDefault(i => i.Id == Id);
                if (Eva_Table_delete != null)
                {
                    //克隆该表格
                    Eva_Table indic = Constant.Clone<Eva_Table>(Eva_Table_delete);
                    indic.IsDelete = (int)IsDelete.Delete;
                    //数据库操作成功再改缓存
                    jsonModel = Constant.Eva_TableService.Update(indic);
                    if (jsonModel.errNum == intSuccess)
                    {
                        Eva_Table_delete.IsDelete = (int)IsDelete.Delete;

                        List<Eva_Table_Header> Eva_Table_Header_List = Constant.Eva_Table_Header_List.Where(t => t.Table_Id == Id).ToList();
                        foreach (Eva_Table_Header item in Eva_Table_Header_List)
                        {
                            item.IsDelete = (int)IsDelete.Delete;
                            var jm = Constant.Eva_Table_HeaderService.Update(item);
                            if (jm.errNum == 0)
                            {
                                Constant.Eva_Table_Header_List.Remove(item);
                            }
                        }

                        List<Eva_TableDetail> Eva_TableDetail_List = Constant.Eva_TableDetail_List.Where(t => t.Eva_table_Id == Id).ToList();
                        foreach (Eva_TableDetail item in Eva_TableDetail_List)
                        {
                            item.IsDelete = (int)IsDelete.Delete;
                            var jsonmodel = Constant.Eva_TableDetailService.Update(item);
                            if (jsonmodel.errNum == 0)
                            {
                                Constant.Eva_TableDetail_List.Remove(item);
                                Indicate_Using_Reduce((int)item.Indicator_Id);
                            }
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "该表格不存在");
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

        #region 启用禁用

        //上锁
        static object obj_Enable_Eva_Table = new object();
        /// <summary>
        /// 编辑表格
        /// </summary>
        public void Enable_Eva_Table(HttpContext context)
        {
            lock (obj_Enable_Eva_Table)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;
                //表格Id
                int table_Id = RequestHelper.int_transfer(Request, "table_Id");
                int IsEnable = RequestHelper.int_transfer(Request, "IsEnable");
                try
                {
                    //获取指定要删除的表格
                    Eva_Table Eva_Table_edit = Constant.Eva_Table_List.FirstOrDefault(i => i.Id == table_Id);
                    if (Eva_Table_edit != null)
                    {

                        //克隆该表格
                        Eva_Table Eva_Table_clone = Constant.Clone<Eva_Table>(Eva_Table_edit);
                        Eva_Table_clone.IsEnable = (byte)IsEnable;
                        //数据库操作成功再改缓存
                        jsonModel = Constant.Eva_TableService.Update(Eva_Table_clone);
                        if (jsonModel.errNum == intSuccess)
                        {
                            Eva_Table_edit.IsEnable = (byte)IsEnable;
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "编辑失败");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "该表格不存在");
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

        #region 创建编辑表辅助

        /// <summary>
        /// 添加头部内容
        /// </summary>
        /// <param name="table_Id"></param>
        /// <param name="Request"></param>
        public static void Table_Header(int table_Id, string head_value, string lisss)
        {
            try
            {

                if (!string.IsNullOrEmpty(head_value))
                {
                    //序列化表表头固化
                    List<head_value> head_values = JsonConvert.DeserializeObject<List<head_value>>(head_value);
                    int i = 0;
                    foreach (var item in head_values)
                    {
                        Eva_Table_Header header = new Eva_Table_Header()
                        {
                            Custom_Code = (item.Code == null || item.Code == "") ? item.CustomCode : item.Code,
                            Name_Key = item.description,
                            Name_Value = item.name,
                            Table_Id = table_Id,
                            Type = Convert.ToInt32(item.id),
                            CreateTime = DateTime.Now,
                            CreateUID = "",
                            EditTime = DateTime.Now,
                            EditUID = "",
                            IsDelete = (int)IsDelete.No_Delete,
                            IsEnable = (int)IsEnable.Enable,
                            Sort = i,
                        };
                        var josnmodel = Constant.Eva_Table_HeaderService.Add(header);
                        if (josnmodel.errNum == 0)
                        {
                            header.Id = Convert.ToInt32(josnmodel.retData);
                            Constant.Eva_Table_Header_List.Add(header);
                        }
                        i++;
                    }

                }


                if (!string.IsNullOrEmpty(lisss))
                {
                    //序列化表表头固化
                    List<lisss> lisss_s = JsonConvert.DeserializeObject<List<lisss>>(lisss);

                    foreach (var item in lisss_s)
                    {
                        Eva_Table_Header header = new Eva_Table_Header() { Name_Key = item.title, Name_Value = item.name, Table_Id = table_Id, Type = 0 };
                        var josnmodel = Constant.Eva_Table_HeaderService.Add(header);
                        if (josnmodel.errNum == 0)
                        {
                            header.Id = Convert.ToInt32(josnmodel.retData);
                            Constant.Eva_Table_Header_List.Add(header);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        /// <summary>
        /// 表格详情表创建添加
        /// </summary>
        /// <param name="CreateUID"></param>
        /// <param name="EditUID"></param>
        /// <param name="Eva_Table_Add"></param>
        /// <param name="Table_A_List"></param>
        private static void Eva_TableAdd_Helper(string CreateUID, string EditUID, Eva_Table Eva_Table_Add, List<Table_A> Table_A_List)
        {
            var Table_Id = Eva_Table_Add.Id;
            //开启线程操作数据库
            new Thread(() =>
            {

                try
                {
                    foreach (Table_A table_A in Table_A_List)
                    {
                        //表明细列表保证不为null513
                        if (table_A.indicator_list == null) continue;
                        foreach (indicator_list item in table_A.indicator_list)
                        {
                            Eva_TableDetail Eva_TableDetail = new Eva_TableDetail()
                            {
                                CreateTime = DateTime.Now,
                                EditTime = DateTime.Now,
                                CreateUID = CreateUID,
                                EditUID = EditUID,
                                Indicator_Id = (int)item.Id,
                                IndicatorType_Id = (int)item.IndicatorType_Id,
                                IndicatorType_Name = item.IndicatorType_Name,
                                OptionA = item.OptionA,
                                OptionB = item.OptionB,
                                OptionC = item.OptionC,
                                OptionD = item.OptionD,
                                OptionE = item.OptionE,
                                OptionF = item.OptionF,
                                OptionA_S = RequestHelper.decimal_transfer(item.OptionA_S),
                                OptionB_S = RequestHelper.decimal_transfer(item.OptionB_S),
                                OptionC_S = RequestHelper.decimal_transfer(item.OptionC_S),
                                OptionD_S = RequestHelper.decimal_transfer(item.OptionD_S),
                                OptionE_S = RequestHelper.decimal_transfer(item.OptionE_S),
                                OptionF_S = RequestHelper.decimal_transfer(item.OptionF_S),
                                //Indicator_Name = item.Name,
                                IsDelete = (int)IsDelete.No_Delete,
                                IsEnable = (int)IsEnable.Enable,
                                Name = item.Name,
                                QuesType_Id = (int)item.QuesType_Id,
                                Remarks = item.Remarks,
                                Sort = RequestHelper.int_transfer(item.Sort),
                                Root = item.Root,
                                RootID = item.RootID,
                                Eva_table_Id = Table_Id,
                                //评价任务 1，表格设计 0
                                Type = Convert.ToString((int)TableDetail_Type.Table),
                                OptionF_S_Max = item.OptionF_S_Max,

                            };

                            //入库
                            JsonModel model2 = Constant.Eva_TableDetailService.Add(Eva_TableDetail);
                            if (model2.errNum == 0)
                            {
                                //添加到缓存
                                Constant.Eva_TableDetail_List.Add(Eva_TableDetail);
                                Eva_TableDetail.Id = RequestHelper.int_transfer(Convert.ToString(model2.retData));

                                Indicate_Using_Add((int)item.Id);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
            }) { IsBackground = true }.Start();
        }

        #endregion

        #region 指标库引用增加、减少

        /// <summary>
        /// 指标库引用增1
        /// </summary>
        /// <param name="Id"></param>
        private static void Indicate_Using_Add(int Id)
        {
            try
            {
                //指标库的计数
                Indicator Indicator = Constant.Indicator_List.FirstOrDefault(t => t.Id == Id);
                Indicator Indicator_clone = Constant.Clone<Indicator>(Indicator);
                Indicator_clone.UseTimes += 1;
                //直接进行更改
                if (Indicator_clone != null)
                {
                    JsonModel m = Constant.IndicatorService.Update(Indicator);
                    if (m.errNum == 0)
                    {
                        Indicator.UseTimes += 1;
                    }
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }
        /// <summary>
        /// 指标库引用减1
        /// </summary>
        /// <param name="Id"></param>
        private static void Indicate_Using_Reduce(int Id)
        {
            try
            {
                //指标库的计数
                Indicator Indicator = Constant.Indicator_List.FirstOrDefault(t => t.Id == Id);
                Indicator Indicator_clone = Constant.Clone<Indicator>(Indicator);
                if (Indicator_clone.UseTimes > 0)
                {
                    Indicator_clone.UseTimes -= 1;
                    //直接进行更改
                    if (Indicator_clone != null)
                    {
                        JsonModel m = Constant.IndicatorService.Update(Indicator);
                        if (m.errNum == 0)
                        {
                            Indicator.UseTimes -= 1;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region 表格引用次数添加

        public void TableUsingAdd(int? Table_Id)
        {
            try
            {
                //获取表的引用，减少引用次数
                Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => Table_Id == t.Id);
                if (table != null)
                {
                    //克隆该表格
                    Eva_Table table_clone = Constant.Clone<Eva_Table>(table);
                    table_clone.UseTimes += 1;
                    JsonModel m3 = Constant.Eva_TableService.Update(table_clone);
                    if (m3.errNum == 0)
                    {
                        table.UseTimes += 1;
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region 表格引用次数减少

        public void TableUsingReduce(int? Table_Id)
        {
            try
            {
                //获取表的引用，减少引用次数
                Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => Table_Id == t.Id);
                if (table != null)
                {
                    //克隆该表格
                    Eva_Table table_clone = Constant.Clone<Eva_Table>(table);
                    if (table_clone.UseTimes > 0)
                    {
                        table_clone.UseTimes -= 1;
                        JsonModel m3 = Constant.Eva_TableService.Update(table_clone);
                        if (m3.errNum == 0)
                        {
                            table.UseTimes -= 1;
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion
    }

}
