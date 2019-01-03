<template>
  <div class="home">
    <el-row v-for="(row, index) in 2" :key="row" :offset="index > 0 ? 2 : 0">
      <el-col :span="8" v-for="(col, index) in 2" :key="col" :offset="index > 0 ? 2 : 0">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>项目{{row * 2 + col}}</span>
            <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button>
          </div>
          <div v-for="o in 4" :key="o" class="text item">
            {{'列表内容 ' + o }}
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'home',
  components: {
  }
}
</script>

<style>
.el-row {
    margin-bottom: 20px;
  }
</style>
