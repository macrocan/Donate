<template>
  <el-row>
    <el-col :span="9">
      <div class="head-wrap">波场公益平台</div>
    </el-col>

    <el-col :span="3">
      <div class="head-wrap">当前地址</div>
    </el-col>
    <el-col :span="12">
      <div class="head-wrap">{{address()}}</div>
    </el-col>
  </el-row>
</template>
<script>
// @ is an alias to /src

export default {
  methods: {
    address() {
      console.log(this.$store.state.tronWeb.tronData.address)
      return this.$store.state.tronWeb.tronData.address
    }
  }
}
</script>

<style scoped>
.head-wrap{

}
</style>