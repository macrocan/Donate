<template>
  <div class="home">
    <el-row v-for="(row, index) in rowCount" :key="index" :offset="index > 0 ? 2 : 0">
      <el-col :span="8">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>项目{{row * 2 - 2}}</span>
            <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button>
          </div>
          <div class="text item">
            {{contracts[row * 2 - 2]}}
          </div>
        </el-card>
      </el-col>
      <el-col v-if="isShow(row * 2 - 1)" :span="8">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>项目{{row * 2 - 1}}</span>
            <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button>
          </div>
          <div class="text item">
            {{contracts[row * 2 - 1]}}
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
  data() {
    return {
    }
  },
  async beforeCreate () {
    console.log('register tron web Action dispatched from Home.vue')
    if (this.$store.state.tronWeb.tronData.instance){
      await this.$store.dispatch('GET_DEPLOYED_CONTRACT')
    }
  },
  components: {
  },
  methods: {
    isShow(index){
      return (index < this.contracts.length)
    }
  },
  computed: {
    rowCount() {
      return Math.round(this.contracts.length / 2)
    },
    contracts() {
      return this.$store.state.tronWeb.deployedContract
    },
  }
}
</script>

<style>
.el-row {
    margin-top: 10px;
    margin-bottom: 10px;
  }
</style>
