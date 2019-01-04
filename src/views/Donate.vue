<template>
  <div>
    <div class="donate">
      <h1>This is an donate page</h1>
      <p>This is an donate page</p>
    </div>
    <el-form ref="form" :model="form" label-width="80px">
      <el-form-item label="amount" prop="amount" :rules="[
        { required: true, message: '不能为空'},
        { type: 'number', message: '必须为数字值'}
      ]">
        <el-input type="amount" v-model.number="form.amount"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('form')">捐助</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'home',
  data() {
      return {
        form: {
          amount: 0
        }
      }
  },
  beforeCreate () {
    console.log(this.$store.state.tronWeb.contractInfo)
  },
  components: {
  },
  methods: {

  },
  computed: {

  }
}
</script>