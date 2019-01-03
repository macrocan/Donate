<template>
<el-form ref="form" :model="form" label-width="80px">
  <el-form-item label="amount">
    <el-input v-model="form.amount"></el-input>
  </el-form-item>
  <el-form-item label="title">
    <el-input v-model="form.title"></el-input>
  </el-form-item>
  <el-form-item label="desc">
    <el-input v-model="form.desc"></el-input>
  </el-form-item>
  <el-form-item label="materialHash">
    <el-input v-model="form.materialHash"></el-input>
  </el-form-item>
  <el-form-item label="materialUrl">
    <el-input v-model="form.materialUrl"></el-input>
  </el-form-item>
  <el-form-item label="donateToAddr">
    <el-input v-model="form.donateToAddr"></el-input>
  </el-form-item>
  <el-form-item>
    <el-button type="primary" @click="onSubmit">立即创建</el-button>
    <el-button>取消</el-button>
  </el-form-item>
</el-form>
</template>

<script>
  export default {
    data() {
      return {
        form: {
          amount: '',
          title: '',
          desc: '',
          materialHash: '',
          materialUrl: '',
          donateToAddr: '',
        }
      }
    },
    methods: {
      onSubmit() {
        console.log('submit!');
      }
    }
  }
</script>
